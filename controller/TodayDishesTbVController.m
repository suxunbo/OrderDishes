//
//  JinRiTiXingViewController.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/7.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "TodayDishesTbVController.h"
#import "AddDishesViewController.h"

#import "TbViewCellDishes.h"
#import "TbViewCellDishesToday.h"




@interface TodayDishesTbVController ()
{
    AppDelegate *delegate_;
}

@property (weak, nonatomic) IBOutlet UILabel *labelTotalCount;

@end

@implementation TodayDishesTbVController

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate_ = [UIApplication sharedApplication].delegate;
    delegate_.mArrayDishesTodayModels = [NSMutableArray arrayWithCapacity:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [delegate_.mArrayDishesTodayModels count];
}


 - (TbViewCellDishesToday *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TbViewCellDishesToday *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayDishesTbVControllerCell" forIndexPath:indexPath];
    ModelDishes *model = (ModelDishes *)[delegate_.mArrayDishesTodayModels objectAtIndex:indexPath.row];
    
    cell.modelDishes = model;
    cell.labelDishesName.text = [NSString stringWithFormat:@"%@\t(%lu)",model.stringDishesName,(unsigned long)model.uIntegerCount];
    cell.delegate = self;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDishesHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelDishes *model = (ModelDishes *)[delegate_.mArrayDishesTodayModels objectAtIndex:indexPath.row];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入该菜品份数" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.uIntegerCount];
    }];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                             {
                                                 [alertController dismissViewControllerAnimated:YES completion:nil];
                                                 model.uIntegerCount = [[alertController.textFields firstObject].text integerValue];
                                                 [self reloadTodayDishes:model];
                                                 [self caculateTotalPrice];
                                                 
                                             }];

    [alertController addAction:alertAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark  - 今日菜品添加删除数据
- (void)addTodayDishes:(ModelDishes *)dishes
{
    /// 添加至今日的菜品默认count为1
    dishes.uIntegerCount = 1;
    /// 插入新增菜品数据
    [self.tableView beginUpdates];
    [delegate_.mArrayDishesTodayModels addObject:dishes];
    NSUInteger index = [delegate_.mArrayDishesTodayModels indexOfObject:dishes];
    NSArray *indexArray = @[[NSIndexPath indexPathForRow:index inSection:0]];
    [self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:YES];
    [self.tableView endUpdates];
    
    [self caculateTotalPrice];
}

-(void)deleteTodayDishes:(ModelDishes *)dishes
{
    /// 删除菜品数据
    [self.tableView beginUpdates];
    NSUInteger index = [delegate_.mArrayDishesTodayModels indexOfObject:dishes];
    [delegate_.mArrayDishesTodayModels removeObject:dishes];
    NSArray *indexArray = @[[NSIndexPath indexPathForRow:index inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:YES];
    [self.tableView endUpdates];
    
    [self reloadAllDishesRowState:dishes];
    
    [self caculateTotalPrice];
}

-(void)reloadTodayDishes:(ModelDishes *)dishes
{
    /// 修改菜品数量后，reload
    [self.tableView beginUpdates];
    NSUInteger index = [delegate_.mArrayDishesTodayModels indexOfObject:dishes];
    NSArray *indexArray = @[[NSIndexPath indexPathForRow:index inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:YES];
    [self.tableView endUpdates];
}

#pragma mark  - 点菜完毕后计算今日菜品总价格

- (IBAction)todayDishesDone:(id)sender
{
    /// 以当前时间为列表 保存菜单数据
    NSDate *date =[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *locationString=[dateformatter stringFromDate:date];
    
    NSString *dirPath = [[DataUploadDownload shared] historySavePath];
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.archiver",dirPath,locationString];
    
    if ([NSKeyedArchiver archiveRootObject:delegate_.mArrayDishesTodayModels toFile:fileName])
    {
        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
                                                              message:@"今日菜单保存成功"
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:@"提示"
                                                              message:@"今日菜单保存失败"
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    [self reloadHistoryTbView];
}

- (void)caculateTotalPrice
{
    CGFloat totalPrice = 0;
    CGFloat totalVIPPrice = 0;
    
    for (ModelDishes *dishes in delegate_.mArrayDishesTodayModels)
    {
        totalPrice += (dishes.floatDishesPrice * dishes.uIntegerCount);
        totalVIPPrice += (dishes.floatDishesVIPPrice * dishes.uIntegerCount);
    }
    
    [self.labelTotalCount setText:[NSString stringWithFormat:@"原价%0.2f元     会员价%0.2f元",totalPrice, totalVIPPrice]];
}

#pragma mark - 今日菜谱删除数据时，告知AllDishesTbvController更新该菜谱的选择状态
-(void)reloadAllDishesRowState:(ModelDishes *)dishes
{
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:UINavigationControllerTypeAll]).topViewController performSelector:@selector(reloadAllDishesRowState:) withObject:dishes];
}

#pragma mark - 今日菜单保存后，告知HistoryTbViewController 刷新数据
-(void)reloadHistoryTbView
{
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:UINavigationControllerTypeHistory]).topViewController performSelector:@selector(reloadHistoryTbView)];
}

@end
