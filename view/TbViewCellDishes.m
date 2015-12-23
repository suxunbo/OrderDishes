//
//  TbViewCellDishes.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/9.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "TbViewCellDishes.h"

@interface TbViewCellDishes ()
{
    AppDelegate *delegate_;
}
@end

@implementation TbViewCellDishes

- (void)awakeFromNib
{
    // Initialization code
    [self initViews];
    delegate_ = [UIApplication sharedApplication].delegate;
}

-(void)initViews
{
    self.imageViewDishesPhoto = [UIImageView new];
    [self.contentView addSubview:self.imageViewDishesPhoto];
    self.labelDishesName = [UILabel new];
    [self.contentView addSubview:self.labelDishesName];
    self.labelDishesPrice = [UILabel new];
    [self.contentView addSubview:self.labelDishesPrice];
    self.labelDishesDescribing = [UILabel new];
    [self.contentView addSubview:self.labelDishesDescribing];
    self.buttonDishesAction = [UIButton new];
    [self.contentView addSubview:self.buttonDishesAction];
    
    [self.imageViewDishesPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).with.offset(kTableViewCellDishesSpacing);
        make.bottom.mas_equalTo(self.contentView).with.offset(-kTableViewCellDishesSpacing);
        make.width.mas_equalTo(kTableViewCellDishesHeight-2*kTableViewCellDishesSpacing);
    }];
    
    /// 与imageViewDishesPhoto等宽等高
    [self.buttonDishesAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.mas_equalTo(self.imageViewDishesPhoto);
        make.right.mas_equalTo(self.contentView).with.offset(-kTableViewCellDishesSpacing);
    }];
    
    [self.labelDishesName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageViewDishesPhoto);
        make.left.mas_equalTo(self.imageViewDishesPhoto.mas_right).with.offset(kTableViewCellDishesSpacing);
        make.right.mas_equalTo(self.buttonDishesAction.mas_left).with.offset(-kTableViewCellDishesSpacing);
        make.height.mas_equalTo((kTableViewCellDishesHeight-4*kTableViewCellDishesSpacing)/3.0);
    }];
    
    [self.labelDishesPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelDishesName.mas_bottom).with.offset(kTableViewCellDishesSpacing);
        make.left.mas_equalTo(self.labelDishesName);
        make.size.mas_equalTo(self.labelDishesName);
    }];
    
    [self.labelDishesDescribing mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.labelDishesPrice.mas_bottom).with.offset(kTableViewCellDishesSpacing);
        make.left.mas_equalTo(self.labelDishesName);
        make.size.mas_equalTo(self.labelDishesName);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelDishesName.font = [UIFont boldSystemFontOfSize:15];
    self.labelDishesPrice.font = [UIFont italicSystemFontOfSize:13];
    self.labelDishesDescribing.font = [UIFont systemFontOfSize:13];
}

-(void)setModelDishes:(ModelDishes *)modelDishes
{
    _modelDishes = modelDishes;
    self.labelDishesPrice.text = [NSString stringWithFormat:@"价格:%0.2f元      会员价:%0.2f元",modelDishes.floatDishesPrice,modelDishes.floatDishesVIPPrice];
    self.labelDishesDescribing.text = modelDishes.stringDishesDescribing;
    
    [self performSelector:@selector(setButtonDishesActionState:) withObject:[delegate_.mArrayDishesTodayModels containsObject:modelDishes]?@"YES":@"NO"];
}

@end
