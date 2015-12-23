//
//  DishesModel.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/8.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "ModelDishes.h"

@implementation ModelDishes
- (instancetype)initID:(NSString *)stringDishesID name:(NSString *)stringDishesName price:(CGFloat)floatDishesPrice VIPPrice:(CGFloat)floatDishesVIPPrice describing:(NSString *)stringDishesDescribing
{
    self = [super init];
    if (self) {
        self.stringDishesID = stringDishesID;
        self.stringDishesName = stringDishesName;
        self.floatDishesPrice = floatDishesPrice;
        self.floatDishesVIPPrice = floatDishesVIPPrice;
        self.stringDishesDescribing = stringDishesDescribing;
    }
    return self;
}

- (instancetype)initName:(NSString *)stringDishesName price:(CGFloat)floatDishesPrice VIPPrice:(CGFloat)floatDishesVIPPrice describing:(NSString *)stringDishesDescribing
{
    self = [super init];
    if (self) {
        self.stringDishesName = stringDishesName;
        self.floatDishesPrice = floatDishesPrice;
        self.floatDishesVIPPrice = floatDishesVIPPrice;
        self.stringDishesDescribing = stringDishesDescribing;
    }
    return self;
}

-(NSString *)stringDishesDescribing
{
    if (!_stringDishesDescribing ||
        [_stringDishesDescribing isEqualToString:@""])
    {
        return @"暂无描述";
    }
    return _stringDishesDescribing;
}


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:self.stringDishesID forKey:@"stringDishesID"];
    [coder encodeObject:self.stringDishesName forKey:@"stringDishesName"];
    [coder encodeFloat:self.floatDishesPrice forKey:@"floatDishesPrice"];
    [coder encodeFloat:self.floatDishesVIPPrice forKey:@"floatDishesVIPPrice"];
    [coder encodeObject:self.stringDishesDescribing forKey:@"stringDishesDescribing"];
    [coder encodeInt:self.uIntegerCount forKey:@"uIntegerCount"];
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        self.stringDishesID = [decoder decodeObjectForKey:@"stringDishesID"];
        self.stringDishesName = [decoder decodeObjectForKey:@"stringDishesName"];
        self.floatDishesPrice = [decoder decodeFloatForKey:@"floatDishesPrice"];
        self.floatDishesVIPPrice = [decoder decodeFloatForKey:@"floatDishesVIPPrice"];
        self.stringDishesDescribing = [decoder decodeObjectForKey:@"stringDishesDescribing"];
        self.uIntegerCount = [decoder decodeIntegerForKey:@"uIntegerCount"];
    }
    return self;
}


@end
