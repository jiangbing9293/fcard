//
//  OpenDoorViewController.m
//  FCARD
//
//  Created by FREELANCER on 14-7-8.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "OpenDoorViewController.h"
#import "PacketStruct.h"
#import "MainMenuViewController.h"
#import "MyTool.h"

@interface OpenDoorViewController ()

@end

@implementation OpenDoorViewController
@synthesize socket = _socket;
@synthesize m1 = _m1;
@synthesize m2 = _m2;
@synthesize m3 = _m3;
@synthesize m4 = _m4;

UIImage *off;
UIImage *on;
char OP[4];
int flag;
bool isConnected;
bool isStop;
-(void)getConnectedTimeout
{
    int i = CONNECTED_TIME_OUT;
    while (i-- > 0 && !isStop)
    {
        NSLog(@"i:%d",i);
        if (isConnected) {
            break;
        }
        if (i == 1) {
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
//        off = [UIImage imageNamed:@"remotedoor_off_bg.png"];
        on = [UIImage imageNamed:@"remotedoor_on_bg.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isStop = false;
    memset(OP, 0, 4);
    if(DOORNUM == 1)
    {
        [_mBtn2 setHidden:YES];
        [_mBtn3 setHidden:YES];
        [_mBtn4 setHidden:YES];
        
        [_m2 setHidden:YES];
        [_m3 setHidden:YES];
        [_m4 setHidden:YES];
    }
    else if(DOORNUM == 2)
    {
        [_mBtn3 setHidden:YES];
        [_mBtn4 setHidden:YES];
        
        [_m3 setHidden:YES];
        [_m4 setHidden:YES];
    }
    else{
        
    }
    _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    flag  =  arc4random() % 10000;
    NSError *err = nil;
    if(![_socket connectToHost:device.dev_address onPort:[device.dev_port intValue] error:&err])
    {
        NSLog(@"%@",err.description);
        [MyTool showAlert:@"网络连接失败"];
    }else
    {
        NSLog(@"ok open port");
    }
    [self performSelectorInBackground:@selector(getConnectedTimeout) withObject:nil];
    _m1.text = device.m1;
    _m2.text = device.m2;
    _m3.text = device.m3;
    _m4.text = device.m4;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
    isStop = true;
}
- (void)dealloc
{
    [_mBtn1 release];
    [_mBtn2 release];
    [_mBtn3 release];
    [_mBtn4 release];
    [super dealloc];
    [_m1 release];
    [_m2 release];
    [_m3 release];
    [_m4 release];
    
    [off release];
    [on release];
    
    [_socket release];
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
- (IBAction)opend1:(id)sender
{
   
    [(UIButton *)sender setImage:[UIImage imageNamed:@"remotedoor_off_bg.png"] forState:UIControlStateNormal];
    [(UIButton *)sender  setImage:[UIImage imageNamed:@"remotedoor_on_bg.png"] forState:UIControlStateHighlighted];
    OP[0] = 1;
    [self showDilog];
}
- (IBAction)opend2:(id)sender
{
    
    [(UIButton *)sender setImage:[UIImage imageNamed:@"remotedoor_off_bg.png"] forState:UIControlStateNormal];
    [(UIButton *)sender  setImage:[UIImage imageNamed:@"remotedoor_on_bg.png"] forState:UIControlStateHighlighted];
    OP[1] = 1;
    [self showDilog];
}
- (IBAction)opend3:(id)sender
{
    
    [(UIButton *)sender setImage:[UIImage imageNamed:@"remotedoor_off_bg.png"] forState:UIControlStateNormal];
    [(UIButton *)sender  setImage:[UIImage imageNamed:@"remotedoor_on_bg.png"] forState:UIControlStateHighlighted];
    OP[2] = 1;
    [self showDilog];
}
- (IBAction)opend4:(id)sender
{
   
    [(UIButton *)sender setImage:[UIImage imageNamed:@"remotedoor_off_bg.png"] forState:UIControlStateNormal];
    [(UIButton *)sender  setImage:[UIImage imageNamed:@"remotedoor_on_bg.png"] forState:UIControlStateHighlighted];
    
    OP[3] = 1;
    [self showDilog];
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
    if (t_data[25] == RESP && t_data[26] == RESP_OK) {
        [MyTool showAlert:@"开门成功"];
        memset(OP, 0, sizeof(OP));
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
/**
 *@ 提示输入开门密码
 */
-(void)showDilog
{
    // show change password dialog
    [_socket writeData:[MainMenuViewController getPacket:OPEN_DOOR_CONTROL data_length:OPEN_DOOR_DATALENGTH data:OP len:sizeof(OP)] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入开门密码" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", NSLocalizedString(@"关闭", nil), nil];
//    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
//    [alert show];
//    [alert release];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"lickedButtonAtIndex:%ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *pwd = textField.text;
        NSLog(@"pwd:%@",pwd);
        [_socket writeData:[MainMenuViewController getPacket:OPEN_DOOR_CONTROL data_length:OPEN_DOOR_DATALENGTH data:OP len:sizeof(OP)] withTimeout:-1 tag:flag];
        [_socket readDataWithTimeout:-1 tag:flag];
    }
}
@end
