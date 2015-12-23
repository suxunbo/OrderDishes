//
//  HistoryTbViewController.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/9.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "HistoryTbViewController.h"

@interface HistoryTbViewController ()
{
    NSMutableArray *arrayDataSource;
}
@end

@implementation HistoryTbViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayDataSource = [NSMutableArray arrayWithCapacity:0];
    
    [self reloadHistoryTbView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadHistoryTbView
{
    NSString *dirPath = [[DataUploadDownload shared] historySavePath];
    if (arrayDataSource)
    {
        [arrayDataSource removeAllObjects];
    }
    [arrayDataSource addObjectsFromArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTbViewControllerCell" forIndexPath:indexPath];
    cell.textLabel.text = [arrayDataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dirPath = [[DataUploadDownload shared] historySavePath];
    NSString *filePath = [dirPath stringByAppendingPathComponent:[arrayDataSource objectAtIndex:indexPath.row]];
    NSArray *dishesArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSMutableString *mStringHistory = [NSMutableString stringWithString:@"\n"];
    for(ModelDishes *modies in dishesArray)
    {
        [mStringHistory appendString:modies.stringDishesName];
        [mStringHistory appendString:@"\n"];
    }
    
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"历史菜单"
                                                          message:mStringHistory
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
