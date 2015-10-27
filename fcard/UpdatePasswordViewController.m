//
//  UpdatePasswordViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "MyKeyChainHelper.h"
#import "MyTool.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

@synthesize old_pwd = _old_pwd;
@synthesize n_pwd = _n_pwd;
@synthesize submit_pwd = _submit_pwd;

NSString *o;
NSString *n;
NSString *sm;

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
    o =[[NSString alloc]initWithString:[MyKeyChainHelper getPasswordWithService:KEY_PASSWORD]];
}
- (void)dealloc
{
    [super dealloc];
    [_old_pwd release];
    [_n_pwd release];
    [_submit_pwd release];
    
    [o release];
    [n release];
    [sm release];

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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 12)
        return NO; // return NO to not change text
    return YES;
    
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
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
- (IBAction)submit:(id)sender
{
    if ([o isEqualToString:_old_pwd.text] == NO) {
        [MyTool showAlert:@"提示" msg:@"旧密码错误"];
        return;
    }
    n = [[NSString alloc]initWithString: _n_pwd.text];
    sm = [[NSString alloc]initWithString: _submit_pwd.text];
    if([n isEqualToString:@""] || [sm isEqualToString:@""])
    {
        [MyTool showAlert:@"提示" msg:@"密码不能为空"];
        return;
    }
    if ([sm isEqualToString:n] == NO) {
        [MyTool showAlert:@"提示" msg:@"两次密码不一致"];
        return;
    }
    
    [MyKeyChainHelper savePsaaword:sm psaawordService:KEY_PASSWORD];
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];

}
@end
