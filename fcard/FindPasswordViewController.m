//
//  FindPasswordViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-6-29.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "freelancerViewController.h"
#import "MyKeyChainHelper.h"
#import "MyTool.h"

@interface FindPasswordViewController ()

@end

@implementation FindPasswordViewController

@synthesize pwd_question = _pwd_question;
@synthesize pwd_answer = _pwd_answer;
@synthesize pwd_new = _pwd_new;
@synthesize pwd_submit = _pwd_submit;

NSString *question;
NSString *answer;
NSString *p_new;
NSString *p_submit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        question = [[NSString alloc]init];
        answer = [[NSString alloc] init];
        p_new = [[NSString alloc] init];
        p_submit = [[NSString alloc] init];    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    question = [MyKeyChainHelper getQuestionWithService:KEY_QUESTION];
    if(question == nil || [question isEqualToString:@""])
    {
        [MyKeyChainHelper saveQuestion:@"你的名字？" questionService:KEY_QUESTION];
        [_pwd_question setText:@"你的名字？"];
    }
    else
    {
        [_pwd_question setText:question];
    }
}

-(void)dealloc
{
    [super dealloc];
    
    [question release];
    [answer release];
    [p_new release];
    [p_submit release];
    
    [_pwd_question release];
    [_pwd_answer release];
    [_pwd_new release];
    [_pwd_submit release];
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
-(IBAction)clk_back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
-(IBAction)clk_submit:(id)sender
{
    answer = [MyKeyChainHelper getAnswerWithService:KEY_ANSWER];
    if (answer == nil || [answer isEqualToString:@""]) {
        [MyKeyChainHelper saveAnswser:@"SYSTEM" answerService:KEY_ANSWER];
        answer = @"SYSTEM";
    }
    if ([answer isEqualToString:_pwd_answer.text] == NO) {
        [MyTool showAlert:@"提示" msg:@"密码答案错误"];
        return;
    }
    p_new = _pwd_new.text;
    p_submit = _pwd_submit.text;
    if([p_new isEqualToString:@""] || [p_submit isEqualToString:@""])
    {
        [MyTool showAlert:@"提示" msg:@"密码不能为空"];
        return;
    }
    if ([p_new isEqualToString:p_submit] == NO) {
        [MyTool showAlert:@"提示" msg:@"两次密码不一致"];
        return;
    }
    
    [MyKeyChainHelper savePsaaword:p_submit psaawordService:KEY_PASSWORD];
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
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
