//
//  AddDishesTbVController.h
//  OrderDishes
//
//  Created by 于建峰 on 15/12/8.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDishesViewController : UIViewController

/// 新建的dishes
@property (nonatomic, retain) ModelDishes *modelDishes;

@property (nonatomic, assign) BOOL update;

@end
