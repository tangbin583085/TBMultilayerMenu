//
//  TBMenuItemViewController.h
//  MultilayerMenu
//
//  Created by Ben on 2018/1/25.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBMenuItem.h"

@protocol TBMenuItemDelegate <NSObject>

@required
/** 数据源 */
- (NSArray<TBMenuItem *> *)tb_menuItemsSource;

@optional
/** 选中的item */
- (void)tb_selectedMenuItemsSource:(NSArray<TBMenuItem *> *)seletedArray;


@end

@interface TBMenuItemViewController : UIViewController

@property (nonatomic, weak)id<TBMenuItemDelegate> delegate;

/** 选中全部or取消全部 */
- (void)tb_editAllItems:(BOOL)selectedAll;

/** 选中的Item */
- (NSArray<TBMenuItem *> *)tb_selectedItems;

/** 数据总数 */
@property (nonatomic, assign, readonly) NSInteger totalCount;

@end
