
//
//  TBCustomViewController.m
//  MultilayerMenu
//
//  Created by hanchuangkeji on 2018/1/25.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import "TBCustomViewController.h"
#import "TBMenuItem.h"
#import <MJExtension/MJExtension.h>

@interface TBCustomViewController () <TBMenuItemDelegate>

/** 全选按钮 */
@property (nonatomic, strong) UIButton *allBtn;

@end

@implementation TBCustomViewController

- (void)viewDidLoad {
    
    // set delegate before viewDidLoad
    // 在viewDidLoad之前设置代理
    self.delegate = self;
    [super viewDidLoad];
    
    [self setupNav];
}


- (void)setupNav {
    
    self.title = @"多级菜单";
    
    UIButton *allBtn = [[UIButton alloc] init];
    [allBtn setTitle:@"全选" forState:(UIControlStateNormal)];
    [allBtn setTitle:@"反选" forState:(UIControlStateSelected)];
    [allBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [allBtn sizeToFit];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    self.allBtn = allBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:allBtn];
    
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"已选对象" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    [btn sizeToFit];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(getSelectedMenuItems) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)allBtnClick:(UIButton *)sender {
    /** 选中全部or取消全部 */
    sender.selected = !sender.selected;
    [self tb_editAllItems:sender.selected];
}

- (void)getSelectedMenuItems {
    NSArray<TBMenuItem *> *selectedItems = [self tb_selectedItems];
    NSLog(@"已经选中的items: %@", selectedItems);
}

#pragma mark - <TBMenuItemDelegate>
-(NSArray<TBMenuItem *> *)tb_menuItemsSource {
    
    // 本地模拟数据
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"b" ofType:@"plist"];
    NSArray *date = [NSArray arrayWithContentsOfFile:filePath];
    return [TBMenuItem mj_objectArrayWithKeyValuesArray:date];
}

- (void)tb_selectedMenuItemsSource:(NSArray<TBMenuItem *> *)seletedArray {
    
    // 改变全选按钮状态
    self.allBtn.selected = seletedArray.count == self.totalCount;
    
    NSLog(@"seletedArray: %@", seletedArray);
}


@end
