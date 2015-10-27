//
//  ChangeDoorNameViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-7-31.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "ChangeDoorNameViewController.h"
#import "MyTool.h"
#import "MainMenuViewController.h"

@interface ChangeDoorNameViewController ()

@end

@implementation ChangeDoorNameViewController

@synthesize ip = _ip;
@synthesize sn = _sn;
@synthesize m1 = _m1;
@synthesize m2 = _m2;
@synthesize m3 = _m3;
@synthesize m4 = _m4;

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
    if (device != nil) {
        _ip.text = device.dev_address;
        _sn.text = device.dev_sn;
        
        _m1.text = device.m1;
        _m2.text = device.m2;
        _m3.text = device.m3;
        _m4.text = device.m4;
        
        if (DOORNUM == 1) {
            [_lbM2 setHidden:YES];
            [_lbM3 setHidden:YES];
            [_lbM4 setHidden:YES];
            [_m2 setHidden:YES];
            [_m3 setHidden:YES];
            [_m4 setHidden:YES];
        }
        else if(DOORNUM == 2){
            [_lbM3 setHidden:YES];
            [_lbM4 setHidden:YES];
            [_m3 setHidden:YES];
            [_m4 setHidden:YES];
        }
    }
}

- (void) dealloc
{
    [_lbM1 release];
    [_lbM2 release];
    [_lbM3 release];
    [_lbM4 release];
    [super dealloc];
    [_ip release];
    [_sn release];
    [_m1 release];
    [_m2 release];
    [_m3 release];
    [_m4 release];
    
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
- (IBAction)submit:(id)sender
{
    if([[_m1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [MyTool showAlert:@"m1不能为空"];
        return;
    }
    if([[_m2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [MyTool showAlert:@"m2不能为空"];
        return;
    }
    if([[_m3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [MyTool showAlert:@"m3不能为空"];
        return;
    }
    if([[_m4.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        [MyTool showAlert:@"m4不能为空"];
        return;
    }
    
    if (database != NULL)
    {
        [device setM1:[[NSString alloc] initWithFormat:@"%@", [_m1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        [device setM2:[[NSString alloc] initWithFormat:@"%@", [_m2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        [device setM3:[[NSString alloc] initWithFormat:@"%@", [_m3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        [device setM4:[[NSString alloc] initWithFormat:@"%@", [_m4.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
        
        if(![database executeUpdate:@"UPDATE device SET m1=?, m2=?, m3=?, m4=? where dev_sn=?",
             _m1.text,_m2.text,_m3.text,_m4.text,device.dev_sn])
        {
            NSLog(@"Fail to update device to database.");
        }
    }
//    [self dismissViewControllerAnimated:YES completion:^(void){}];
    MainMenuViewController *main = [[MainMenuViewController alloc]initWithNibName:@"MainMenuViewController" bundle:nil];
    [self presentViewController:main animated:YES completion:nil];
    [main release];
}

- (IBAction)TextField_DidEndOnExit:(id)sender
{
    // 隐藏键盘.
    [sender resignFirstResponder];
}
- (IBAction)View_TouchDown:(id)sender
{
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 256.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

@end
