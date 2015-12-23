//
//  DataUploadDownload.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/10.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "DataUploadDownload.h"

@implementation DataUploadDownload

+ (DataUploadDownload *)shared
{
    static DataUploadDownload *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(NSString *)historySavePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *dirPath = [documents stringByAppendingPathComponent:kHistoryPath];
    return dirPath;
}
@end
