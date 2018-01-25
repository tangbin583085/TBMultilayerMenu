TBMultilayerMenu
==============

简介
==============
iOS开发中，我们经常会用到多级菜单，但是苹果原生控件并没有给开发者提供多层次的控件（只提供了seciont 和 row），所以需要我们开发者根据原生控件自定义多层次的控件。常见于部门，商品分类等UI应用。

安装
==============
我并没有提供到pod上，所以需要使用的朋友们可以上GitHub，然后下载demo代码直接使用即可。

特性
==============
- **无限层次**: 支持无限层次延伸
- **继承**: 继承TBMenuItemViewController，自定义自己的VC.

Demo
==============
![aa.gif](http://upload-images.jianshu.io/upload_images/7078206-9226d0804a030fbb.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


如何用
==============

- 继承TBMenuItemViewController。
- 实现代理，设置相关属性。

```
@required
/** 数据源 */
- (NSArray<TBMenuItem *> *)tb_menuItemsSource;

@optional
/** 选中的item */
- (void)tb_selectedMenuItemsSource:(NSArray<TBMenuItem *> *)seletedArray;

```

实现思路
==============
1, cell的多级层次显示利用model的index适当缩进
2,增加利用insertRowsAtIndexPaths函数添加展开的cell
3,删除利用deleteRowsAtIndexPaths函数移除关闭的cell


授权
==============
TBScrollViewEmpty完全公开源代码给开发者使用。
使用TBScrollViewEmpty应遵守MIT协议. 详情见协议文件。

Company and Organization
==============
@Shanghai,HC&nbsp;&nbsp;&nbsp;@Shanghai,HK&nbsp;&nbsp;&nbsp;@Shanghai,SW

Github和源码
==============
[ TBMultilayerMenu](https://github.com/tangbin583085/TBMultilayerMenu)

<br/>
