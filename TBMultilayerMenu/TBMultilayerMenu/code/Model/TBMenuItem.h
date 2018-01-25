//
//  TBMenuItem.h
//  MultilayerMenu
//
//  Created by Ben on 2018/1/25.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBMenuItem : NSObject

/** 名字 */
@property (nonatomic, strong) NSString *name;
/** 子层 */
@property (nonatomic, strong) NSArray<TBMenuItem *> *subs;

#pragma mark - < 辅助属性 >

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 是否展开 */
@property (nonatomic, assign) BOOL isUnfold;

/** 是否能展开 */
@property (nonatomic, assign) BOOL isCanUnfold;

/** 当前层级 */
@property (nonatomic, assign) NSInteger index;



@end
