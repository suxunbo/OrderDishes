//
//  TbViewCellDishesAll.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/10.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "TbViewCellDishesAll.h"

@interface TbViewCellDishesAll ()
{
    BOOL selected_;
}
@end

@implementation TbViewCellDishesAll

-(void)setButtonDishesActionState:(NSString *)choose
{
    selected_ = [choose boolValue];
    if (!selected_)
    {
        [self.buttonDishesAction setBackgroundColor:[UIColor redColor]];
        [self.buttonDishesAction setTitle:@"点菜" forState:UIControlStateNormal];
    }
    else
    {
        [self.buttonDishesAction setBackgroundColor:[UIColor blueColor]];
        [self.buttonDishesAction setTitle:@"取消" forState:UIControlStateNormal];
    }
    [self.buttonDishesAction addTarget:self action:@selector(buttonDishesActionClick) forControlEvents:UIControlEventTouchUpInside];
}


-(void)buttonDishesActionClick
{
    if (selected_)
    {
        [self.buttonDishesAction setBackgroundColor:[UIColor redColor]];
        [self.buttonDishesAction setTitle:@"点菜" forState:UIControlStateNormal];
        
        [self.delegate performSelector:@selector(deleteTodayDishes:) withObject:self.modelDishes];
    }
    else
    {
        [self.buttonDishesAction setBackgroundColor:[UIColor blueColor]];
        [self.buttonDishesAction setTitle:@"取消" forState:UIControlStateNormal];
        
        [self.delegate performSelector:@selector(addTodayDishes:) withObject:self.modelDishes];
    }
    selected_ = !selected_;
}

@end
