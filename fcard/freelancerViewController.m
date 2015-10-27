//
//  freelancerViewController.m
//  FCARD
//
//  Created by FREELANCER on 14-6-25.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "freelancerViewController.h"
#import "MyKeyChainHelper.h"
#import "FindPasswordViewController.h"
#import "DeviceListViewController.h"
#import "MyTool.h"

@interface freelancerViewController ()
{
   
}
@end

@implementation freelancerViewController

@synthesize alert = _alert;
@synthesize pwd = _pwd;
@synthesize savePwd = _savePwd;

- (void)viewDidLoad
{
    [super viewDidLoad];
   	// Do any additional setup after loading the view, typically from a nib.
    _txtVersion.text = [NSString stringWithFormat:@"版本v%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [MyKeyChainHelper savePsaaword:@"" psaawordService:KEY_PASSWORD];
    _savePwd = [[NSString alloc]initWithString: [MyKeyChainHelper getPasswordWithService:KEY_PASSWORD]];
    NSLog(@"_savePwd:%@",_savePwd);
    if(_savePwd == nil || [_savePwd isEqualToString:@""])
    {
        _alert.text = @"提示，请输入初始密码";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请设置你的安全密码锁：\n系统设置中可修改密码！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", NSLocalizedString(@"确定", nil), nil];
        [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        alert.tag = 2;
        [alert show];
        [alert release];
    }
    else
    {
        _alert.text = @"提示，请输入验证密码";
    }
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _pwd = nil;
    _savePwd = nil;
}

-(void)dealloc
{
    [_txtVersion release];
    [super dealloc];
    [_pwd release];
    [_savePwd release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 12)
        return NO; // return NO to not change text
    return YES;
    
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 256.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
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

-(IBAction)clk_find_pwd:(id)sender
{
    UIViewController *findPwd = [[FindPasswordViewController alloc]initWithNibName:@"FindPasswordViewController" bundle:nil];
    [self presentViewController:findPwd animated:YES completion:^(void){}];
}
-(IBAction)clk_submit:(id)sender
{
    NSString *tPwd = [[NSString alloc]initWithString: _pwd.text];
    
    if (tPwd == nil || [tPwd isEqualToString:@""]) {
        [MyTool showAlert:@"提示" msg:@"验证密码不能为空"];
        return;
    }
//    if (_savePwd == nil) {
//        [MyKeyChainHelper savePsaaword:_pwd.text psaawordService:KEY_PASSWORD];
//    }
    NSLog(@"savePwd:%@,tPwd:%@",_savePwd,tPwd);
    if([_savePwd isEqualToString:tPwd])
    {
        _pwd.text = nil;
        UIViewController *dev_list = [[DeviceListViewController alloc]initWithNibName:@"DeviceListViewController" bundle:nil];
        [self presentViewController:dev_list animated:YES completion:^(void){}];
    }
    else
    {
        [MyTool showAlert:@"提示" msg:@"密码错误，验证失败"];
    }
}
#pragma mark - UIAlertViewDelegate implementation
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSString *pwd = textField.text;
            NSLog(@" pwd %@",pwd);
            if (pwd == nil || [pwd isEqualToString:@""])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请设置你的安全密码锁：\n系统设置中可修改密码！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", NSLocalizedString(@"确定", nil), nil];
                [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
                alert.tag = 2;
                [alert show];
                [alert release];
                return;
            }
            _savePwd = [[NSString alloc] initWithString:pwd];
            [MyKeyChainHelper savePsaaword:pwd psaawordService:KEY_PASSWORD];
        }
        return;
    }
    
}
@end
