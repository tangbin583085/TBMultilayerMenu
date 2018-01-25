//
//  TBMenuItemCell.h
//  MultilayerMenu
//
//  Created by Ben on 2018/1/25.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBMenuItem;
@class TBMenuItemCell;

@protocol TBMenuItemCellDelegate <NSObject>

- (void)cell:(TBMenuItemCell *)cell didSelectedBtn:(UIButton *)sender;

@end

@interface TBMenuItemCell : UITableViewCell

/** 菜单项模型 */
@property (nonatomic, strong) TBMenuItem *menuItem;

/** 代理 */
@property (nonatomic, weak) id<TBMenuItemCellDelegate> delegate;

@end
