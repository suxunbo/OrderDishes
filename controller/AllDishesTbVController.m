//
//  QuanBuTiXingViewController.m
//  OrderDishes
//
//  Created by 于建峰 on 15/12/7.
//  Copyright © 2015年 yu.jianfeng. All rights reserved.
//

#import "AllDishesTbVController.h"
#import "AddDishesViewController.h"


#import "TbViewCellDishes.h"
#import "TbViewCellDishesAll.h"

@interface AllDishesTbVController ()
{
    AppDelegate *delegate_;
    NSArray *arrayAlphabet_;
}
@end

@implementation AllDishesTbVController

#pragma IBOutlet IBAction
-(IBAction)cancle:(UIStoryboardSegue *)segue
{
    
}

-(IBAction)save:(UIStoryboardSegue *)segue
{
    AddDishesViewController *dishesTbvC = segue.sourceViewController;
    ModelDishes *modelDishes = dishesTbvC.modelDishes;
    
    if(modelDishes)
    {
        /// 如果菜品更细则reload,如果菜品新增则insert
        if (dishesTbvC.update)
        {
            [self reloadAllDishesRowState:modelDishes];
        }
        else
        {
            [self insertAllDishesRow:modelDishes];
        }
    }
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate_ = [UIApplication sharedApplication].delegate;
    
    arrayAlphabet_ =  @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",
                       @"H",@"I",@"J",@"K",@"L",@"M",@"N",
                       @"O",@"P",@"Q",@"R",@"S",@"T",
                       @"U",@"V",@"W",@"X",@"Y",@"Z",
                       @"#"
                       ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayAlphabet_ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[delegate_.mDictionaryAllDishes objectForKey:[arrayAlphabet_ objectAtIndex:section]] count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [arrayAlphabet_ objectAtIndex:section];
}

 - (TbViewCellDishesAll *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TbViewCellDishesAll *cell = [tableView dequeueReusableCellWithIdentifier:@"AllDishesTbVControllerCell" forIndexPath:indexPath];
    ModelDishes *model = (ModelDishes *)[[delegate_.mDictionaryAllDishes objectForKey:[arrayAlphabet_ objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.modelDishes = model;
    cell.labelDishesName.text = model.stringDishesName;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellDishesHeight;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arrayAlphabet_;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModelDishes *modelDishes = (ModelDishes *)[[delegate_.mDictionaryAllDishes objectForKey:[arrayAlphabet_ objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"addDishes" sender:modelDishes];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ModelDishes *model = (ModelDishes *)[[delegate_.mDictionaryAllDishes objectForKey:[arrayAlphabet_ objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        [self deleteAllDishesRow:model];
    }
}

#pragma mark - 添加删除菜品数据，有TbViewCellDishes上的button使用
-(void)addTodayDishes:(ModelDishes *)dishes
{
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:UINavigationControllerTypeToday]).topViewController performSelector:@selector(addTodayDishes:) withObject:dishes];
}

-(void)deleteTodayDishes:(ModelDishes *)dishes
{
    [((UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:UINavigationControllerTypeToday]).topViewController performSelector:@selector(deleteTodayDishes:) withObject:dishes];
}

#pragma mark - 全部菜品cell的insert、remove、reload
-(void)reloadAllDishesRowState:(ModelDishes *)dishes
{
    /// 当全部菜品页的tableView Row发生变化时：通过今日菜品页取消、修改菜品信息等
    [self.tableView beginUpdates];
    NSString *firstCharactor = [StringTransform firstCharactor:dishes.stringDishesName];
    NSUInteger section = [arrayAlphabet_ indexOfObject:firstCharactor];
    NSUInteger row = [[delegate_.mDictionaryAllDishes objectForKey:firstCharactor] indexOfObject:dishes];
    NSArray *indexArray = @[[NSIndexPath indexPathForRow:row inSection:section]];
    [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:YES];
    [self.tableView endUpdates];
}

- (void)insertAllDishesRow:(ModelDishes *)dishes
{
    /// 插入新增菜品数据
    /// 这里的数据与delegate中的数据一致，已经在插入数据库时进行了调整，因此无需额外添加。
    NSString *firstCharactor = [StringTransform firstCharactor:dishes.stringDishesName];
    NSUInteger section = [arrayAlphabet_ indexOfObject:firstCharactor];
    NSUInteger row = [[delegate_.mDictionaryAllDishes objectForKey:firstCharactor] indexOfObject:dishes];
    [self.tableView beginUpdates];
    NSArray *indexArray = @[[NSIndexPath indexPathForRow:row inSection:section]];
    [self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:YES];
    [self.tableView endUpdates];

}

- (void)deleteAllDishesRow:(ModelDishes *)dishes
{
    /// 删除菜品数据
    NSString *firstCharactor = [StringTransform firstCharactor:dishes.stringDishesName];
    NSUInteger section = [arrayAlphabet_ indexOfObject:firstCharactor];
    NSUInteger row = [[delegate_.mDictionaryAllDishes objectForKey:firstCharactor] indexOfObject:dishes];
    [self.tableView beginUpdates];
    /// 这里的数据与delegate中的数据一致，已经在删除数据库时进行了调整，因此无需额外删除。
    [[DatabaseManagerDishes shared] deleteDishes:dishes];
    NSArray *indexArray = @[[NSIndexPath indexPathForRow:row inSection:section]];
    [self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:YES];
    [self.tableView endUpdates];
}

#pragma mark - prepareForSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addDishes"] &&
        [sender isKindOfClass:[ModelDishes class]])
    {
        /// [sender isKindOfClass:[ModelDishes class]] 表明是通过点击cell进入菜品更新页
        AddDishesViewController *addDishesViewController = segue.destinationViewController;
        addDishesViewController.modelDishes = sender;
    }
}

@end
