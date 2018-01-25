//
//  TBMenuItemViewController.m
//  MultilayerMenu
//
//  Created by Ben on 2018/1/25.
//  Copyright © 2018年 Ben. All rights reserved.
//

#import "TBMenuItemViewController.h"
#import "TBMenuItem.h"
#import "TBMenuItemCell.h"
#import <MJExtension/MJExtension.h>
#import "UIView+Extension.h"

@interface TBMenuItemViewController () <TBMenuItemCellDelegate, UITableViewDelegate, UITableViewDataSource>

/** 菜单项 */
@property (nonatomic, strong) NSMutableArray<TBMenuItem *> *menuItems;

/** 当前需要展示的数据 */
@property (nonatomic, strong) NSMutableArray<TBMenuItem *> *latestShowMenuItems;

/** 以前需要展示的数据 */
@property (nonatomic, strong) NSMutableArray<TBMenuItem *> *oldShowMenuItems;

/** 已经选中的选项, 用于回调 */
@property (nonatomic, strong) NSMutableArray<TBMenuItem *> *selectedMenuItems;

@property (nonatomic, weak) UITableView *tableView;


@end

@implementation TBMenuItemViewController

static NSString *TBMenuItemId = @"TBMenuItemCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tb_setup];
    
    [self setupTableView];
}

#pragma mark - < 懒加载 >
- (NSMutableArray<TBMenuItem *> *)latestShowMenuItems {
    if (!_latestShowMenuItems) {
        _latestShowMenuItems = [[NSMutableArray alloc] init];
    }
    return _latestShowMenuItems;
}

- (NSMutableArray<TBMenuItem *> *)selectedMenuItems {
    if (!_selectedMenuItems) {
        _selectedMenuItems = [[NSMutableArray alloc] init];
    }
    return _selectedMenuItems;
}

- (NSMutableArray<TBMenuItem *> *)menuItems {
    
    if (_menuItems == nil) {
        if ([self.delegate respondsToSelector:@selector(tb_menuItemsSource)]) {
            _menuItems = [[self.delegate tb_menuItemsSource] mutableCopy];;
        } else {
            
            // 本地模拟数据
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"plist"];
            NSArray *date = [NSArray arrayWithContentsOfFile:filePath];
            _menuItems = [TBMenuItem mj_objectArrayWithKeyValuesArray:date];
        }
    }
    return _menuItems;
}

#pragma mark - < 基本设置p >

- (void)tb_setup {
    
    // 初始化需要展示的数据
    [self setupRowCount];
    
    // 初始化总数
    [self getTotalCount:self.menuItems];
}

- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    // 小技巧，去除底部分割线
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 45;
    [self.tableView registerClass:[TBMenuItemCell class] forCellReuseIdentifier:TBMenuItemId];
}

#pragma mark - < 选中数据 >
- (void)tb_editAllItems:(BOOL)selectedAll {
    
    [self selected:selectedAll menuItems:self.menuItems];
    
    [self.selectedMenuItems removeAllObjects];
    [self editSelectedArrayMenuItems:self.menuItems];
    
    // 执行代理
    if ([self.delegate respondsToSelector:@selector(tb_selectedItems)]) {
        [self.delegate tb_selectedMenuItemsSource:self.selectedMenuItems];
    }
}

- (NSArray<TBMenuItem *> *)tb_selectedItems {
    return self.selectedMenuItems;
}


/**
 取消或选择, 某一数值中所有的选项, 包括子层级

 @param selected 是否选中
 @param menuItems 选项数组
 */
- (void)selected:(BOOL)selected menuItems:(NSArray<TBMenuItem *> *)menuItems {
    for (int i = 0; i < menuItems.count; i++) {
        TBMenuItem *menuItem = menuItems[i];
        menuItem.isSelected = selected;
        if (menuItem.isCanUnfold) {
            [self selected:selected menuItems:menuItem.subs];
        }
    }
    [self.tableView reloadData];
}

/**
 获取选中数据
 */
- (void)editSelectedArrayMenuItems:(NSArray<TBMenuItem *> *)menuItems {
    for (int i = 0; i < menuItems.count; i++) {
        TBMenuItem *menuItem = menuItems[i];
        if (menuItem.isSelected) {
            [self.selectedMenuItems addObject:menuItem];
        }
        if (menuItem.subs.count) {
            [self editSelectedArrayMenuItems:menuItem.subs];
        }
    }
}

#pragma mark - < 添加可以展示的选项 >

- (void)setupRowCount {
    // 清空当前所有展示项
    [self.latestShowMenuItems removeAllObjects];
    
    // 重新添加需要展示项, 并设置层级, 初始化0
    [self setupRouCountWithMenuItems:self.menuItems index:0];
}

/**
 将需要展示的选项添加到latestShowMenuItems中, 此方法使用递归添加所有需要展示的层级到latestShowMenuItems中

 @param menuItems 需要添加到latestShowMenuItems中的数据
 @param index 层级, 即当前添加的数据属于第几层
 */
- (void)setupRouCountWithMenuItems:(NSArray<TBMenuItem *> *)menuItems index:(NSInteger)index {
    for (int i = 0; i < menuItems.count; i++) {
        TBMenuItem *item = menuItems[i];
        // 设置层级
        item.index = index;
        // 将选项添加到数组中
        [self.latestShowMenuItems addObject:item];
        // 判断该选项的是否能展开, 并且已经需要展开
        if (item.isCanUnfold && item.isUnfold) {
            // 当需要展开子集的时候, 添加子集到数组, 并设置子集层级
            [self setupRouCountWithMenuItems:item.subs index:index + 1];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.latestShowMenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TBMenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:TBMenuItemId forIndexPath:indexPath];
    cell.menuItem = self.latestShowMenuItems[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TBMenuItem *menuItem = self.latestShowMenuItems[indexPath.row];
    if (!menuItem.isCanUnfold) return;
    
    self.oldShowMenuItems = [NSMutableArray arrayWithArray:self.latestShowMenuItems];
    
    // 设置展开闭合
    menuItem.isUnfold = !menuItem.isUnfold;
    // 更新被点击cell的箭头指向
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    
    // 设置需要展开的新数据
    [self setupRowCount];
    
    // 判断老数据和新数据的数量, 来进行展开和闭合动画
    // 定义一个数组, 用于存放需要展开闭合的indexPath
    NSMutableArray<NSIndexPath *> *indexPaths = @[].mutableCopy;
    
    // 如果 老数据 比 新数据 多, 那么就需要进行闭合操作
    if (self.oldShowMenuItems.count > self.latestShowMenuItems.count) {
        // 遍历oldShowMenuItems, 找出多余的老数据对应的indexPath
        for (int i = 0; i < self.oldShowMenuItems.count; i++) {
            // 当新数据中 没有对应的item时
            if (![self.latestShowMenuItems containsObject:self.oldShowMenuItems[i]]) {
                NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [indexPaths addObject:subIndexPath];
            }
        }
        // 移除找到的多余indexPath
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationTop)];
    }else {
        // 此时 新数据 比 老数据 多, 进行展开操作
        // 遍历 latestShowMenuItems, 找出 oldShowMenuItems 中没有的选项, 就是需要新增的indexPath
        for (int i = 0; i < self.latestShowMenuItems.count; i++) {
            if (![self.oldShowMenuItems containsObject:self.latestShowMenuItems[i]]) {
                NSIndexPath *subIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                [indexPaths addObject:subIndexPath];
            }
        }
        // 插入找到新添加的indexPath
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationTop)];
    }
}

#pragma mark - 总数量item
- (void)getTotalCount:(NSArray<TBMenuItem *> *)array {
    
    for (TBMenuItem *item in array) {
        _totalCount = _totalCount + 1;
        if (item.subs.count) {
            [self getTotalCount:item.subs];
        }
    }
}


#pragma mark - < TBMenuItemCellDelegate >

- (void)cell:(TBMenuItemCell *)cell didSelectedBtn:(UIButton *)sender {
    
    cell.menuItem.isSelected = !cell.menuItem.isSelected;
    
    // 编辑选中与否
    [self.selectedMenuItems removeAllObjects];
    [self editSelectedArrayMenuItems:self.menuItems];
    // 执行代理
    if ([self.delegate respondsToSelector:@selector(tb_selectedItems)]) {
        [self.delegate tb_selectedMenuItemsSource:self.selectedMenuItems];
    }
    
    [self.tableView reloadData];
}


@end




































