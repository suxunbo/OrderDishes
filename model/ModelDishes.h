//
//  DishesModel.h
//  OrderDishes
//
//  Created by 于建峰 on 15/12/8.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ModelDishes : NSObject <NSCoding>

/// 菜品ID
@property(nonatomic, copy) NSString *stringDishesID;

/// 菜品名称
@property(nonatomic, copy) NSString *stringDishesName;

/// 菜品单价
@property(nonatomic, assign) CGFloat floatDishesPrice;

/// 菜品会员价
@property(nonatomic, assign) CGFloat floatDishesVIPPrice;

/// 菜品描述
@property(nonatomic, copy) NSString *stringDishesDescribing;

/// 菜品份数
@property(nonatomic, assign) NSUInteger uIntegerCount;


- (instancetype)initName:(NSString *)stringDishesName price:(CGFloat)floatDishesPrice VIPPrice:(CGFloat)floatDishesVIPPrice describing:(NSString *)stringDishesDescribing;

- (instancetype)initID:(NSString *)stringDishesID name:(NSString *)stringDishesName price:(CGFloat)floatDishesPrice VIPPrice:(CGFloat)floatDishesVIPPrice describing:(NSString *)stringDishesDescribing;
@end
