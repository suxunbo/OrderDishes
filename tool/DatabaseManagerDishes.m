//
//  DatabaseManager.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/8.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "DatabaseManagerDishes.h"

#import "FMDB.h"

/// 菜品数据表名
#define dishesTable          @"dishesTable"
/// 数据库表字段
#define DishesID             @"DishesID"
#define DishesName           @"DishesName"
#define DishesPrice          @"DishesPrice"
#define DishesVIPPrice       @"DishesVIPPrice"
#define DishesDescribing     @"DishesDescribing"


static NSString *const databasePath = @"/data.db";


@interface DatabaseManagerDishes ()
{
    FMDatabase *database_;
    AppDelegate *delegate;
}

@end

@implementation DatabaseManagerDishes

+ (DatabaseManagerDishes *)shared
{
    static DatabaseManagerDishes *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 数据库与菜品表创建
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [paths objectAtIndex:0];
        NSString *dbPath  = [documents stringByAppendingPathComponent:databasePath];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath])
        {
            database_ = [FMDatabase databaseWithPath:dbPath];
        }
        else
        {
            database_ = [FMDatabase databaseWithPath:dbPath];
            /// 创建数据库表
            [self createDishesTable];
            /// 创建存放历史路径的dir
            [self createDirctory];
        }
        
        delegate = [UIApplication sharedApplication].delegate;
        if (!delegate.mDictionaryAllDishes)
        {
            delegate.mDictionaryAllDishes = [NSMutableDictionary dictionaryWithCapacity:0];
        }
    }
    return self;
}

- (void)createDirctory
{
    NSString *dirPath = [[DataUploadDownload shared] historySavePath];
    BOOL success = [[NSFileManager defaultManager]createDirectoryAtPath:dirPath
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:nil];
    if (!success)
    {
        NSLog(@"error when creating directory archiver");
    }
    else
    {
        NSLog(@"success when creating directory archiver");
    }
}

- (void)createDishesTable
{
    if ([database_ open])
    {
        /*
         NULL       值是一个 NULL 值。
         INTEGER	值是一个带符号的整数，根据值的大小存储在 1、2、3、4、6 或 8 字节中。
         REAL       值是一个浮点值，存储为 8 字节的 IEEE 浮点数字。
         TEXT       值是一个文本字符串，使用数据库编码（UTF-8、UTF-16BE 或 UTF-16LE）存储。
         BLOB       值是一个 blob 数据，完全根据它的输入存储。
         **/
        NSString *sqlCreateTable =  [NSString stringWithFormat:
                                     @"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT UNIQUE, %@ REAL, %@ REAL,%@ TEXT )",dishesTable, DishesID, DishesName, DishesPrice, DishesVIPPrice, DishesDescribing];
        
        BOOL res = [database_ executeUpdate:sqlCreateTable];
        if (!res)
        {
            NSLog(@"error when creating db table");
        }
        else
        {
            NSLog(@"success to creating db table");
        }
        [database_ close];
    }
    
    /// 初始化原始数据
    [self addDishes];
}

#pragma mark - 菜品数据 增 ，删， 改
-(BOOL) insertDishes:(ModelDishes *)dishes
{
    if ([self checkData:dishes])
    {
        @synchronized(self)
        {
            if ([database_ open])
            {
                NSString *insertSql= [NSString stringWithFormat:
                                      @"INSERT INTO %@ (%@, %@, %@, %@) VALUES ('%@', '%f', '%f', '%@')",
                                      dishesTable,
                                      DishesName,
                                      DishesPrice,
                                      DishesVIPPrice,
                                      DishesDescribing,
                                      dishes.stringDishesName,
                                      dishes.floatDishesPrice,
                                      dishes.floatDishesVIPPrice,
                                      dishes.stringDishesDescribing];
                
                BOOL res = [database_ executeUpdate:insertSql];
                if (res)
                {
                    NSString *firstCharactor = [StringTransform firstCharactor:dishes.stringDishesName];
                    if ([delegate.mDictionaryAllDishes objectForKey:firstCharactor])
                    {
                        NSMutableArray * mArray = [NSMutableArray arrayWithArray:[delegate.mDictionaryAllDishes objectForKey:firstCharactor]];
                        [mArray addObject:dishes];
                        [delegate.mDictionaryAllDishes setObject:mArray forKey:firstCharactor];
                    }
                    else
                    {
                        [delegate.mDictionaryAllDishes setObject:@[dishes] forKey:firstCharactor];
                    }
                }
                else
                {
                    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
                                                                          message:@"新增菜品信息失败"
                                                                cancelButtonTitle:@"确定"
                                                                otherButtonTitles:nil, nil];
                    [alertView show];
                }
                [database_ close];
                return res;
            }
            return NO;
        }
    }
    return NO;
}

-(BOOL) updateDishes:(ModelDishes *)dishes orignalDishes:(ModelDishes *)orignalDishes
{
    if ([self checkData:dishes])
    {
        @synchronized(self)
        {
            if ([database_ open])
            {
                NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@', %@ = '%f', %@ = '%f', %@ = '%@' WHERE %@ = '%@'",
                                       dishesTable,
                                       DishesName,
                                       dishes.stringDishesName,
                                       DishesPrice,
                                       dishes.floatDishesPrice,
                                       DishesVIPPrice,
                                       dishes.floatDishesVIPPrice,
                                       DishesDescribing,
                                       dishes.stringDishesDescribing,
                                       DishesID,
                                       dishes.stringDishesID];
                
                BOOL res = [database_ executeUpdate:updateSql];
                if (res)
                {
                    NSString *firstCharactor = [StringTransform firstCharactor:dishes.stringDishesName];
                    if ([delegate.mDictionaryAllDishes objectForKey:firstCharactor])
                    {
                        NSMutableArray * mArray = [NSMutableArray arrayWithArray:[delegate.mDictionaryAllDishes objectForKey:firstCharactor]];
                        NSUInteger index = [mArray indexOfObject:orignalDishes];
                        [mArray replaceObjectAtIndex:index withObject:dishes];
                        [delegate.mDictionaryAllDishes setObject:mArray forKey:firstCharactor];
                    }
                }
                else
                {
                    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
                                                                          message:@"更新菜品信息失败"
                                                                cancelButtonTitle:@"确定"
                                                                otherButtonTitles:nil, nil];
                    [alertView show];
                }
                [database_ close];
                return res;
            }
            return NO;
        }
    }
    return NO;
}


-(BOOL) deleteDishes:(ModelDishes *)dishes
{
    @synchronized(self)
    {
        if ([database_ open])
        {
            NSString *deleteSql = [NSString stringWithFormat:
                                   @"delete from %@ where %@ = '%@'",
                                   dishesTable,
                                   DishesID,
                                   dishes.stringDishesID];
            BOOL res = [database_ executeUpdate:deleteSql];
            if (res)
            {
                NSString *firstCharactor = [StringTransform firstCharactor:dishes.stringDishesName];
                if ([delegate.mDictionaryAllDishes objectForKey:firstCharactor])
                {
                    NSMutableArray * mArray = [NSMutableArray arrayWithArray:[delegate.mDictionaryAllDishes objectForKey:firstCharactor]];
                    [mArray removeObject:dishes];
                    [delegate.mDictionaryAllDishes setObject:mArray forKey:firstCharactor];
                }
            }
            else
            {
                URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
                                                                      message:@"删除菜品信息失败"
                                                            cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil, nil];
                [alertView show];
            }

            [database_ close];
            
            return res;
        }
        return NO;
    }
}


#pragma mark - 数据加载与预处理
-(void)loadAllDishes
{
    if ([database_ open])
    {
        NSString *loadSql = [NSString stringWithFormat:@"SELECT * FROM %@",dishesTable];
        FMResultSet *result = [database_ executeQuery:loadSql];
        while ([result next]){
            ModelDishes *modelDishes = [[ModelDishes alloc] init];
            modelDishes.stringDishesID = [result stringForColumn:DishesID];
            modelDishes.stringDishesName = [result stringForColumn:DishesName];
            modelDishes.floatDishesPrice = [result doubleForColumn:DishesPrice];
            modelDishes.floatDishesVIPPrice = [result doubleForColumn:DishesVIPPrice];
            modelDishes.stringDishesDescribing = [result stringForColumn:DishesDescribing];
            
            NSString *firstCharactor = [StringTransform firstCharactor:modelDishes.stringDishesName];
            if ([delegate.mDictionaryAllDishes objectForKey:firstCharactor])
            {
                NSMutableArray * mArray = [NSMutableArray arrayWithArray:[delegate.mDictionaryAllDishes objectForKey:firstCharactor]];
                [mArray addObject:modelDishes];
                [delegate.mDictionaryAllDishes setObject:mArray forKey:firstCharactor];
            }
            else
            {
                [delegate.mDictionaryAllDishes setObject:@[modelDishes] forKey:firstCharactor];
            }
        }
        [result close];
    }
    [database_ close];
}



#pragma mark -  插入数据时合法性验证
-(BOOL)checkData:(ModelDishes *)dishes
{
    /// ID自增长
//    if (!dishes.stringDishesID ||
//        [dishes.stringDishesID isEqualToString:@""])
//    {
//        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
//                                                              message:@"菜品ID不允许为空"
//                                                    cancelButtonTitle:@"确定"
//                                                    otherButtonTitles:nil, nil];
//        [alertView show];
//        return NO;
//    }
    
    
    if(!dishes.stringDishesName ||
       [dishes.stringDishesName isEqualToString:@""])
    {
        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
                                                              message:@"菜品名称不允许为空"
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    /// 允许价格为0的菜品，牌价菜
//    if(dishes.floatDishesPrice >= -0.00001 &&
//       dishes.floatDishesPrice <= 0.00001)
//    {
//        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
//                                                              message:@"菜品价格不允许为空"
//                                                    cancelButtonTitle:@"确定"
//                                                    otherButtonTitles:nil, nil];
//        [alertView show];
//        return NO;
//    }
    
    return YES;
}

@end
