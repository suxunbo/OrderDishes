//
//  AddDishesTbVController.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/8.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "AddDishesViewController.h"


@interface AddDishesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *labelID;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelVIPPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelDiscribing;

@property (weak, nonatomic) IBOutlet UITextField *textFieldID;
@property (weak, nonatomic) IBOutlet UITextField *textFieldName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldVIPPrice;
@property (weak, nonatomic) IBOutlet UITextField *textFieldDiscribing;

@end

@implementation AddDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    /// 菜品ID暂不支持更新
    self.textFieldID.userInteractionEnabled = NO;

    if (self.modelDishes)
    {
        self.update = YES;
        self.navigationItem.title = [NSString stringWithFormat:@"%@",self.modelDishes.stringDishesName];

        self.textFieldName.userInteractionEnabled = NO;
        self.textFieldID.text = [NSString stringWithFormat:@"%@",self.modelDishes.stringDishesID];
        self.textFieldName.text = [NSString stringWithFormat:@"%@",self.modelDishes.stringDishesName];
        self.textFieldPrice.text = [NSString stringWithFormat:@"%0.2f",self.modelDishes.floatDishesPrice];
        self.textFieldVIPPrice.text = [NSString stringWithFormat:@"%0.2f",self.modelDishes.floatDishesVIPPrice];
        self.textFieldDiscribing.text = self.modelDishes.stringDishesDescribing;
    }
    else
    {
        self.update = NO;
        
        self.textFieldID.placeholder = @"菜品编号（暂不支持自定义）";
        self.textFieldName.placeholder = @"请输入菜品名称";
        self.textFieldPrice.placeholder = @"请输入菜品价格";
        self.textFieldVIPPrice.placeholder = @"请输入菜品会员价";
        self.textFieldDiscribing.placeholder = @"请输入菜品描述";
    }
}

-(void)initViews
{
    [self.labelID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).with.offset(10);
        make.top.mas_equalTo(self.view).with.offset(64+kAddDishesViewHeight);
        make.height.mas_equalTo(@(kAddDishesViewHeight));
        make.width.mas_equalTo(@(kScreenWidth/3.0));
    }];
    
    [self.textFieldID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(self.labelID);
        make.left.mas_equalTo(self.labelID.mas_right).with.offset(10);
        make.right.mas_equalTo(self.view).with.offset(-10);
    }];
    
    [self.labelName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelID.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.labelID);
    }];
    
    [self.textFieldName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFieldID.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.textFieldID);
    }];
    
    [self.labelPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelName.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.labelID);
    }];
    
    [self.textFieldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFieldName.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.textFieldID);
    }];
    
    [self.labelVIPPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelPrice.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.labelID);
    }];
    
    [self.textFieldVIPPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFieldPrice.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.textFieldID);
    }];
    
    [self.labelDiscribing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelVIPPrice.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.labelID);
    }];
    
    [self.textFieldDiscribing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textFieldVIPPrice.mas_bottom).with.offset(kAddDishesViewSpacing);
        make.left.height.width.mas_equalTo(self.textFieldID);
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - segue

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"saveAddDishes"])
    {
        /// save按钮验证数有效性。有效数据返回。无效数据弹出提示框不返回。
        ModelDishes *modelDishes = [[ModelDishes alloc] init];
        modelDishes.stringDishesID = self.textFieldID.text;
        modelDishes.stringDishesName = self.textFieldName.text;
        modelDishes.floatDishesPrice = [self.textFieldPrice.text floatValue];
        modelDishes.floatDishesVIPPrice = [self.textFieldVIPPrice.text floatValue];
        modelDishes.stringDishesDescribing = self.textFieldDiscribing.text;

        if (self.update &&
            self.modelDishes)
        {
            /// 删除原始数据，新增修改数据
            if (![[DatabaseManagerDishes shared] updateDishes:modelDishes orignalDishes:self.modelDishes])
            {
                self.modelDishes = nil;
                return NO;
            }
            else
            {
                self.modelDishes = modelDishes;
            }
            return YES;
        }
        else
        {
            if (![[DatabaseManagerDishes shared] insertDishes:modelDishes])
            {
                self.modelDishes = nil;
                return NO;
            }
            else
            {
                self.modelDishes = modelDishes;
            }
            return YES;
        }
    }
    else if([identifier isEqualToString:@"cancleAddDishes"])
    {
        /// cancle 按钮直接返回
        return YES;
    }
    return YES;
}

@end
