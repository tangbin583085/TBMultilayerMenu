//
//  TBMenuItem.m
//  MultilayerMenu
//
//  Created by Ben on 2018/1/25.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import "TBMenuItem.h"

@implementation TBMenuItem

/**
 指定subs数组中存放TBMenuItem类型对象
 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"subs" : [TBMenuItem class]};
}

/**
 判断是否能够展开, 当subs中有数据时才能展开
 */
- (BOOL)isCanUnfold {
    return self.subs.count > 0;
}

@end
