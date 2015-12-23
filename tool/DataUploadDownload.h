//
//  DataUploadDownload.h
//  OrderDishes
//
//  Created by 于建峰 on 15/12/10.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUploadDownload : NSObject

+ (DataUploadDownload *)shared;

/*!
 *  @author yu.jianfeng, 15-12-16 17:12:15
 *
 *  @brief 历史保存路径
 *
 */
-(NSString *)historySavePath;
@end
