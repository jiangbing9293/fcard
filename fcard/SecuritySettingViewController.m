//
//  SecuritySettingViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-11.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "SecuritySettingViewController.h"
#import "MainMenuViewController.h"
#import "PacketStruct.h"
#import "MyTool.h"

@interface SecuritySettingViewController ()

@end

@implementation SecuritySettingViewController

@synthesize socket = _socket;

MySecuritySetingStruct *sSet;
int flag;

int status;
int in_delay;
int out_delay;
int set_password;
int exit_password;
int alarm_time;
bool isConnected;
bool isTermial;
-(void)getConnectedTimeout
{
    int i = CONNECTED_TIME_OUT;
    while (i-- > 0 && !isTermial)
    {
        NSLog(@"i:%d",i);
        if (isConnected) {
            break;
        }
        if (i == 1) {
            [_indicator setHidden:YES];
            [MyTool showAlert:@"网络连接超时"];
            return;
        }
        sleep(1);
    }
}
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
    isConnected = false;
    isTermial = false;
    sSet = malloc(sizeof(MySecuritySetingStruct));
    memset(sSet, 0, sizeof(MySecuritySetingStruct));
    
    _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    flag  =  arc4random() % 10000;
    NSError *err = nil;
    [_indicator startAnimating];
    if(![_socket connectToHost:device.dev_address onPort:[device.dev_port intValue] error:&err])
    {
        NSLog(@"%@",err.description);
        [MyTool showAlert:@"网络连接失败"];
    }
    else
    {
        NSLog(@"ok open port");
    }
    [_socket writeData:[MainMenuViewController getPacket:READ_SECURITY_CONTROL data_length:READ_SECURIY_DATALENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [self performSelectorInBackground:@selector(getConnectedTimeout) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
    isTermial = true;
}
- (void)dealloc {
    [_btnStatus release];
    [_editInDelayTime release];
    [_editOutDelayTime release];
    [_editSetPassword release];
    [_editCancelPassword release];
    [_editAlarmTime release];
    [_indicator release];
    [super dealloc];
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
    if([_editSetPassword.text length] < 5 || [_editSetPassword.text length] > 8)
    {
        [MyTool showAlert:@"布防密码5-8位数字"];
        return;
    }
    if([_editCancelPassword.text length] < 5 || [_editCancelPassword.text length] > 8)
    {
        [MyTool showAlert:@"撤防密码5-8位数字"];
        return;
    }
    char ch[3];
    char setPwd[4];
    char exitPwd[4];
    char alarmCh[2];
    
    in_delay = [_editInDelayTime.text intValue];
    out_delay = [_editOutDelayTime.text intValue];
    alarm_time = [_editAlarmTime.text intValue];
    
    ch[0] = status;
    ch[1] = in_delay;
    ch[2] = out_delay;
    [self intPasswordToChars:_editSetPassword.text chars:setPwd];
    [self intPasswordToChars:_editCancelPassword.text chars:exitPwd];
    alarmCh[0] = alarm_time >> 8;
    alarmCh[1] = alarm_time;
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendBytes:ch length:3];
    [data appendBytes:setPwd length:4];
    [data appendBytes:exitPwd length:4];
    [data appendBytes:alarmCh length:2];
    [_indicator startAnimating];
    [_socket writeData:[MainMenuViewController getPacket:SET_SECURITY_CONTROL data_length:SET_SECURIY_DATALENGTH data:[data bytes] len:0x0d] withTimeout:-1 tag:flag+1];
     [_socket readDataWithTimeout:-1 tag:flag+1];
}
- (IBAction)changeStatus:(id)sender
{
    if (status == 0) {
        status = 1;
    }
    else{
        status = 0;
    }
    [self initStatus];
}
- (void)initStatus
{
    if (status == 1) {
        [_btnStatus setImage:[UIImage imageNamed:@"switch_on.png"] forState:UIControlStateNormal];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"防盗报警功能未启用，请通过电脑端软件开启次功能!" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil];
        [alert show];
        [alert release];

        [_btnStatus setImage:[UIImage imageNamed:@"switch_off.png"] forState:UIControlStateNormal];
    }
}
- (void)changeData
{
    [self initStatus];
    _editInDelayTime.text = [NSString stringWithFormat:@"%d秒",in_delay];
    _editOutDelayTime.text = [NSString stringWithFormat:@"%d秒",out_delay];
    _editSetPassword.text = [NSString stringWithFormat:@"%d",set_password];
    _editCancelPassword.text  = [NSString stringWithFormat:@"%d",exit_password];
    _editAlarmTime.text  = [NSString stringWithFormat:@"%d秒",alarm_time];

}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接到:%@",host);
    isConnected = true;
    [_socket readDataWithTimeout:-1 tag:flag];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"断开连接:%@",sock.connectedHost);
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"readData %@:,%@",sock.connectedHost,data);
    const char *t_data = [data bytes];
    [_indicator stopAnimating];
    if (tag == flag && t_data[25] == 0x31) {
        sSet = (MySecuritySetingStruct*)t_data;
        status = sSet->status;
        in_delay = sSet->in_delay_time;
        out_delay = sSet->out_delay_time;
        set_password = [self getPasswordFromChars:sSet->set_password];
        exit_password = [self getPasswordFromChars:sSet->cancel_password];
        alarm_time = (sSet->alarm_time[0]&0xff) << 8 | (sSet->alarm_time[1]&0xff);
        [self changeData];
    }
    else if(tag == flag+1)
    {
        if (t_data[25] == RESP && t_data[26] == RESP_OK) {
            [MyTool showAlert:@"设置成功"];
            [self dismissViewControllerAnimated:YES completion:^(void){}];
        }
        else if(t_data[26] == RESP_ERROR_PWD)
        {
            [MyTool showAlert:@"通讯密码错误"];
        }
        else if(t_data[26] == RESP_ERROR_CHECK)
        {
            [MyTool showAlert:@"校验出错"];
        }

    }
}
-(int)getPasswordFromChars:(char[])data
{
    NSString *str = [[NSString alloc] initWithFormat:@""];
    NSLog(@"===%d,%d,%d,%d",data[0],data[1],data[2],data[3]);
    for (int i = 0; i < 4; ++i)
    {
        NSLog(@"=== %d,%d",data[i]/16,data[i]%16);
        
        if(data[i] == (char)0xff)
        {
            break;
        }
        if (data[i]/16 == 15 || data[i]/16 == -1) {
            break;
        }
        else
        {
           str = [NSString stringWithFormat:@"%@%d",str,(data[i]&0xff)>>4 ];
        }
        if(data[i] % 16 == 15 || data[i]%16 == -1)
        {
            break;
        }
        else
        {
           str = [NSString stringWithFormat:@"%@%d",str,(data[i]&0xFF)%16 ];
        }
    }

    return [str intValue];
}
- (void) intPasswordToChars:(NSString*)pwd chars:(char[])PASSWORD
{
    NSLog(@"============intPasswordToChars %@",pwd);
    
    if ([pwd length] == 8) {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = [pwd substringToIndex:2];
        int t = [thrid intValue];
        PASSWORD[2] = (t/10)*16 + t%10;
        pwd = [pwd substringFromIndex:2];
        NSString *four = pwd;
        int fo = [four intValue];
        PASSWORD[3] = (fo/10)*16 + fo%10;
    }
    else if([pwd length] == 7)
    {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = [pwd substringToIndex:2];
        int t = [thrid intValue];
        PASSWORD[2] = (t/10)*16 + t%10;
        pwd = [pwd substringFromIndex:2];
        NSString *four = pwd ;
        int fo = [four intValue];
        PASSWORD[3] = (fo%10)*16 + 0x0f;
    }
    else if([pwd length] == 6)
    {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = pwd;
        int t = [thrid intValue];
        PASSWORD[2] = (t/10)*16 + t%10;
        PASSWORD[3] =0xff;
    }
    else if([pwd length] == 5)
    {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = pwd ;
        int t = [thrid intValue];
        PASSWORD[2] = (t%10)*16 + 0x0f;
        PASSWORD[3] =0xff;
    }
    else
    {
        PASSWORD[0] = 0xff;
        PASSWORD[1] = 0xff;
        PASSWORD[2] = 0xff;
        PASSWORD[3] = 0xff;
    }
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
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
@end
