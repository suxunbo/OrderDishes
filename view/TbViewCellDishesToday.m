//
//  TbViewCellDishesToday.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/10.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "TbViewCellDishesToday.h"

@implementation TbViewCellDishesToday

-(void)setButtonDishesActionState:(NSString *)choose
{
    [self.buttonDishesAction setBackgroundColor:[UIColor blueColor]];
    [self.buttonDishesAction setTitle:@"取消" forState:UIControlStateNormal];
    [self.buttonDishesAction addTarget:self action:@selector(buttonDishesActionClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buttonDishesActionClick
{
    [self.delegate performSelector:@selector(deleteTodayDishes:) withObject:self.modelDishes];
    
}

@end
