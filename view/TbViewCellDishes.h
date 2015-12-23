//
//  TbViewCellDishes.h
//  OrderDishes
//
//  Created by 于建峰 on 15/12/9.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TbViewCellDishes : UITableViewCell

/// 菜品图片
@property (strong, nonatomic) UIImageView *imageViewDishesPhoto;
/// 菜品名称
@property (strong, nonatomic) UILabel *labelDishesName;
/// 菜品价格
@property (strong, nonatomic) UILabel *labelDishesPrice;
/// 菜品描述
@property (strong, nonatomic) UILabel *labelDishesDescribing;
/// 菜品操作
@property (strong, nonatomic) UIButton *buttonDishesAction;
/// 代理
@property (assign, nonatomic) id delegate;
/// 填充的数据模型
@property (strong, nonatomic) ModelDishes *modelDishes;
/// cell类型
@property (assign, nonatomic) TbViewCellDishesType tbViewCellDishesType;

@end
