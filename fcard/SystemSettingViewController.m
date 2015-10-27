//
//  SystemSettingViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "UpdatePasswordViewController.h"
#import "SetQuestionViewController.h"
#import "SetMonitorRateViewController.h"

@interface SystemSettingViewController ()

@end

@implementation SystemSettingViewController

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
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)updatePassword:(id)sender
{
    UIViewController *update = [[UpdatePasswordViewController alloc]initWithNibName:@"UpdatePasswordViewController" bundle:nil];
    [self presentViewController:update animated:YES completion:^(void){}];
}
- (IBAction)setRefreshRate:(id)sender
{
    UIViewController *rate = [[SetMonitorRateViewController alloc]initWithNibName:@"SetMonitorRateViewController" bundle:nil];
    [self presentViewController:rate animated:YES completion:^(void){}];
}
- (IBAction)setQuestion:(id)sender
{
    UIViewController *ques = [[SetQuestionViewController alloc]initWithNibName:@"SetQuestionViewController" bundle:nil];
    [self presentViewController:ques animated:YES completion:^(void){}];
}
- (IBAction)about:(id)sender
{

}
@end
