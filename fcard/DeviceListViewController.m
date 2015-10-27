//
//  DeviceListViewController.m
//  FCARD
//
//  Created by FREELANCER on 14-7-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceTableViewCell.h"
#import "AddDeviceViewController.h"
#import "EditDeviceViewController.h"
#import "MainMenuViewController.h"
#import "MyTool.h"
#import "MyDevice.h"
#import "freelancerViewController.h"

@interface DeviceListViewController ()

@end

@implementation DeviceListViewController

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_tableView) {
        [_tableView reloadData];
    }
}
- (void)dealloc
{
    [super dealloc];
    [_tableView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [device_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DeviceCellIdentifier = @"DeviceCellIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:DeviceCellIdentifier];
        nibsRegistered = YES;
    }
    
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeviceCellIdentifier];
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:@"DeviceTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:DeviceCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:DeviceCellIdentifier];
    }
   

    NSUInteger row = [indexPath row];
    if([device_list count] > 0 && row < [device_list count])
    {
        MyDevice *dev = [device_list objectAtIndex:row];
        int dNum = [[NSString stringWithFormat:@"%c" ,[[dev dev_sn] characterAtIndex:5]] intValue];
        if (dNum == 1) {
            [cell hidden1];
        }
        else if(dNum == 2)
        {
            [cell hidden2];
        }
        cell.sn = [dev dev_sn];
        cell.m1 = [dev m1];
        cell.m2 = [dev m2];
        cell.m3 = [dev m3];
        cell.m4 = [dev m4];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    return cell;
}
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置划动cell是否出现del按钮，可供删除数据里进行处理
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return true;
}
//设置选中Cell的响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainMenuViewController *main_menu = [[MainMenuViewController alloc]initWithNibName:@"MainMenuViewController" bundle:nil];
    [device setDev:[device_list objectAtIndex:[indexPath row]]];
    [self presentViewController:main_menu animated:YES completion:^(void){}];

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    EditDeviceViewController *edit_view = [[EditDeviceViewController alloc]initWithNibName:@"EditDeviceViewController" bundle:nil];
    edit_view.device = [device_list objectAtIndex:[indexPath row]];
    [self presentViewController:edit_view animated:YES completion:^(void){}];
}

//设置删除时编辑状态
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = [indexPath row];
    [alertView show];
    [alertView release];
    
}

-(IBAction)back:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:^(void){}];
//    UIViewController *controller = [[freelancerViewController alloc] init];
//    [self presentViewController:controller animated:YES completion:^(void){}];
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    freelancerViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"freelancerViewController"];
    [self presentViewController:controller animated:YES completion:^(void){}];
}

-(IBAction)addDev:(id)sender
{
    UIViewController *dev_list = [[AddDeviceViewController alloc]initWithNibName:@"AddDeviceViewController" bundle:nil];
    [self presentViewController:dev_list animated:YES completion:^(void){}];
}
/*
 @function: 提示框协议
 */
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger index = alertView.tag;
    if (index < 0 || index > [device_list count]) {
        return;
    }
    /**
     @buttonIndex:提示框按钮索引
     **/
    if (buttonIndex == 1)
    {
        NSString *dev_sn;
        MyDevice *device = [device_list objectAtIndex: index];
        dev_sn = device.dev_sn;
        if (dev_sn == nil) {
            return;
        }
        if (database != NULL) {
            if (![database executeUpdate:@"DELETE FROM device where dev_sn=?", dev_sn]) {
                NSLog(@"Fail to remove device from database.");
            }
        }
        [device_list removeObjectAtIndex:index];
        [_tableView reloadData];
    }
    
}
@end
