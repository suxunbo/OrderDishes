//
//  Defines.h
//  OrderDishes
//
//  Created by 于建峰 on 15/12/10.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

/// 菜品列表cell高度
#define kTableViewCellDishesHeight 70
/// 菜品列表空间间隔
#define kTableViewCellDishesSpacing 5

/// 菜品添加页控件纵向间距
#define kAddDishesViewSpacing 20
/// 菜品添加页控件高度
#define kAddDishesViewHeight 44

/// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

/// 历史记录保存文件夹名称
#define kHistoryPath @"history"

/// 底部TabBarController
typedef NS_ENUM(NSInteger, UINavigationControllerType) {
    UINavigationControllerTypeToday = 0, /// 今日菜单
    UINavigationControllerTypeAll, /// 全部菜单
    UINavigationControllerTypeRecommand, /// 推荐菜单
    UINavigationControllerTypeHistory /// 历史菜单
};

typedef NS_ENUM(NSInteger, TbViewCellDishesType) {
    /// 点击取消菜品
    TbViewCellDishesTypeToday = 0,
    /// 点击可切换点菜与取消
    TbViewCellDishesTypeAll,
    /// 点击可切换点菜与取消
    TbViewCellDishesTypeRecommand
};

#endif /* Defines_h */
