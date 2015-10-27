//
//  SettingClockViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-3.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "SettingClockViewController.h"
#import "PacketStruct.h"
#import "MainMenuViewController.h"
#import "MyTool.h"

@interface SettingClockViewController ()

@end

@implementation SettingClockViewController

@synthesize indicator = _indicator;

@synthesize socket = _socket;
@synthesize ip = _ip;
@synthesize sn = _sn;
@synthesize dev_date = _dev_date;
@synthesize phone_date = _phone_date;

int flag;
MyDeviceDate *sDevDate;
char pDate[7];
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
    sDevDate = malloc(sizeof(MyDeviceDate));
    memset(sDevDate, 0, sizeof(MyDeviceDate));
    isConnected = false;
    isStop = false;
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
    [_socket writeData:[MainMenuViewController getPacket:DEVICE_TIME_READ_CONTROL data_length:DEVICE_TIME_READ_DATALENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [self performSelectorInBackground:@selector(getConnectedTimeout) withObject:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _indicator.hidden = YES;
    _ip.text = device.dev_address;
    _sn.text = device.dev_sn;
    [MyTool getPhoneDateToDev:pDate];
    _phone_date.text = [MyTool devDateToDate:pDate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
    isStop = true;
}
- (void)dealloc
{
    [super dealloc];
    
    [_ip release];
    [_sn release];
    [_dev_date release];
    [_phone_date release];
    [_indicator release];
    [_socket release];
    free(sDevDate);
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

- (IBAction)updateDate:(id)sender
{
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [_socket writeData:[MainMenuViewController getPacket:DEVICE_TIME_WRITE_CONTROL data_length:DEVICE_TIME_WRITE_DATALENGTH data:pDate len:7] withTimeout:-1 tag:flag+1];
     [_socket readDataWithTimeout:-1 tag:flag+1];
}

- (IBAction)refresh:(id)sender
{
    if (isConnected == false) {
        [MyTool showAlert:@"网络未连接"];
        return;
    }
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [_socket writeData:[MainMenuViewController getPacket:DEVICE_TIME_READ_CONTROL data_length:DEVICE_TIME_READ_DATALENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag];
    [MyTool getPhoneDateToDev:pDate];
    _phone_date.text = [MyTool devDateToDate:pDate];
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
    if ([_indicator isAnimating]) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
    if(tag == flag+1)
    {
        if (t_data[25] == RESP && t_data[26] == RESP_OK) {
            [MyTool showAlert:@"写入成功"];
        }
        else if(t_data[26] == RESP_ERROR_PWD)
        {
            [MyTool showAlert:@"通讯密码错误"];
        }
        else if(t_data[26] == RESP_ERROR_CHECK)
        {
            [MyTool showAlert:@"校验出错"];
        }
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        NSLog(@"写入设备时间");
        return;
    }
    sDevDate = (MyDeviceDate*)t_data;
    _dev_date.text = [MyTool devDateToDate:sDevDate->dev_date];
    NSLog(@"设备时间:%@",_dev_date.text);
}
@end
