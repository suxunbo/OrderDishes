//
//  StringTransform.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/15.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "StringTransform.h"

@implementation StringTransform

+ (NSString *)firstCharactor:(NSString *)aString
{
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    //获取并返回首字母
    unichar charactor = [[pinYin substringToIndex:1] characterAtIndex:0];
    if (charactor >= 'A' && charactor <= 'Z')
    {
        return [pinYin substringToIndex:1];
    }
    else
    {
        return @"#";
    }

}
@end
