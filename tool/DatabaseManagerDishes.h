//
//  DatabaseManager.h
//  OrderDishes
//
//  Created by 于建峰 on 15/12/8.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManagerDishes : NSObject

/*!
 *  @author yu.jianfeng, 15-12-08 14:12:11
 *
 *  @brief 获取数据库单例对象
 *
 */
+ (DatabaseManagerDishes *)shared;


/*!
 *  @author yu.jianfeng, 15-12-08 15:12:39
 *
 *  @brief 菜品存储
 *
 */
-(BOOL) insertDishes:(ModelDishes *)dishes;


/*!
 *  @author yu.jianfeng, 15-12-08 15:12:55
 *
 *  @brief 菜品更新
 *
 */
-(BOOL) updateDishes:(ModelDishes *)dishes orignalDishes:(ModelDishes *)orignalDishes;


/*!
 *  @author yu.jianfeng, 15-12-08 15:12:04
 *
 *  @brief 菜品删除
 *
 */
-(BOOL) deleteDishes:(ModelDishes *)dishes;



#pragma mark - 数据预处理与加载
/*!
 *  @author yu.jianfeng, 15-12-09 16:12:26
 *
 *  @brief 查询所有菜品数据
 *
 */
-(void)loadAllDishes;


@end
