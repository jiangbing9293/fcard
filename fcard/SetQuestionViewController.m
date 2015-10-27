//
//  SetQuestionViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "SetQuestionViewController.h"
#import "MyKeyChainHelper.h"
#import "MyTool.h"

@interface SetQuestionViewController ()

@end

@implementation SetQuestionViewController

@synthesize question = _question;
@synthesize answer = _answer;

NSString *ques;
NSString *anw;

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
      ques = [[NSString alloc]initWithString: [MyKeyChainHelper getQuestionWithService:KEY_QUESTION]];
      anw = [[NSString alloc]initWithString: [MyKeyChainHelper getAnswerWithService:KEY_ANSWER]];
    _question.text = ques;
    _answer.text = anw;
}

- (void)dealloc
{
    [super dealloc];
    [_question release];
    [_answer release];
    [ques release];
    [anw release];
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
    if([_question.text isEqualToString:@""])
    {
        [MyTool showAlert:@"提示" msg:@"提问不能为空"];
        return;
    }
    if([_answer.text isEqualToString:@""])
    {
        [MyTool showAlert:@"提示" msg:@"答案不能为空"];
        return;
    }
    [MyKeyChainHelper saveQuestion:_question.text questionService:KEY_QUESTION];
    [MyKeyChainHelper saveAnswser:_answer.text answerService:KEY_ANSWER];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
@end
