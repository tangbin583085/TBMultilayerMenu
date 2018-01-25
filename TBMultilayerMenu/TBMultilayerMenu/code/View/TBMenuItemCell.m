//
//  TBMenuItemCell.m
//  MultilayerMenu
//
//  Created by Ben on 2018/1/25.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import "TBMenuItemCell.h"
#import "TBMenuItem.h"
#import "UIView+Extension.h"

#define kScreen_Width                       [UIScreen mainScreen].bounds.size.width
#define kScreen_Height                      [UIScreen mainScreen].bounds.size.height

@interface TBMenuItemCell ()

/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;

/** 复选框 */
@property (nonatomic, strong) UIButton *selectBtn;

/** 横线 */
@property (nonatomic, strong) UIView *lineView;

/** 图标 */
@property (nonatomic, strong) UIImageView *arrowImageView;

/** 选中按钮 */
@property (nonatomic, strong) UIButton *btn;

@end

@implementation TBMenuItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.arrowImageView];
        [self.contentView addSubview:self.btn];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        self.selectBtn = [[UIButton alloc] init];
        _selectBtn.size = CGSizeMake(17, 17);
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"options_none_icon"] forState:(UIControlStateNormal)];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"options_selected_icon"] forState:(UIControlStateSelected)];
        _selectBtn.x = 13;
    }
    return _selectBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        
        CGFloat x = self.selectBtn.right + 10;
        CGFloat width = kScreen_Width - x - self.selectBtn.x;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.selectBtn.right + 10, 0, width, 45)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreen_Width - 12, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    }
    return _lineView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_down_icon"]];
        _arrowImageView.size = CGSizeMake(11, 11);
        _arrowImageView.right = kScreen_Width - 14;
    }
    return _arrowImageView;
}

- (UIButton *)btn {
    if (!_btn) {
        self.btn = [[UIButton alloc] init];
        [_btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _btn.backgroundColor = [UIColor clearColor];
    }
    return _btn;
}

#pragma mark - < 布局子控件 >

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectBtn.centerY = self.height * 0.5;
    _titleLabel.height = self.height;
    self.lineView.bottom = self.height;
    _arrowImageView.centerY = self.height * 0.5;
    self.btn.frame = CGRectMake(0, 0, kScreen_Width * 0.5, self.height);
}

#pragma mark - < 点击事件 >

- (void)selectBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cell:didSelectedBtn:)]) {
        [self.delegate cell:self didSelectedBtn:sender];
    }
}

#pragma mark - < set >

- (void)setMenuItem:(TBMenuItem *)menuItem {
    _menuItem = menuItem;
    
    self.titleLabel.text = menuItem.name;
    
    self.selectBtn.selected = menuItem.isSelected;
    
    self.arrowImageView.hidden = !menuItem.isCanUnfold;
    
    self.arrowImageView.image = menuItem.isUnfold ? [UIImage imageNamed:@"select_top_icon"] : [UIImage imageNamed:@"select_down_icon"];
    
    // 每一即错开距离
    CGFloat marin = 15;
    
    CGFloat x = 13 + menuItem.index * marin;
    
    self.selectBtn.x = x;
    self.titleLabel.x = self.selectBtn.right + 10;
    self.titleLabel.width = _arrowImageView.x - 10 - self.titleLabel.x;
    self.lineView.x = x - 1;
    self.lineView.width = kScreen_Width - self.lineView.x - 12;
}


@end




















