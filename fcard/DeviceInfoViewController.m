//
//  DeviceInfoViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-3.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "PacketStruct.h"
#import "MainMenuViewController.h"
#import "MyTool.h"
#import "iToast.h"

@interface DeviceInfoViewController ()

@end

@implementation DeviceInfoViewController

@synthesize indicator = _indicator;
@synthesize version = _version;
@synthesize days = _days;
@synthesize temperature = _temperature;
@synthesize voltage = _voltage;
@synthesize runInfo = _runInfo;
@synthesize socket = _socket;

int flag;
MyDeviceInfo *sDevInfo;
MyFireware *sFireware;
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
    isConnected = false;
    isStop = false;
    sDevInfo = malloc(sizeof(MyDeviceInfo));
    memset(sDevInfo, 0, sizeof(MyDeviceInfo));
    sFireware = malloc(sizeof(MyFireware));
    memset(sFireware, 0, sizeof(MyFireware));
    
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
    [_socket writeData:[MainMenuViewController getPacket:DEVICE_INFO_CONTROL data_length:DEVICE_INFO_DATELENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [_socket writeData:[MainMenuViewController getPacket:FIRMWARE_CONTROL data_length:FIREWARE_DATELENGTH data:nil len:0] withTimeout:-1 tag:flag+1];
    [self performSelectorInBackground:@selector(getConnectedTimeout) withObject:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_indicator startAnimating];
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
    [_version release];
    [_days release];
    [_temperature release];
    [_voltage release];
    [_runInfo release];
    [_indicator release];
    [_socket release];
    free(sDevInfo);
    free(sFireware);
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
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)refresh:(id)sender
{
    if(isConnected == false)
    {
        [[iToast makeText:@"网络未连接"]show];
        return;
    }
    _indicator.hidden = NO;
    [_indicator startAnimating];
    [_socket writeData:[MainMenuViewController getPacket:DEVICE_INFO_CONTROL data_length:DEVICE_INFO_DATELENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [_socket writeData:[MainMenuViewController getPacket:FIRMWARE_CONTROL data_length:FIREWARE_DATELENGTH data:nil len:0] withTimeout:-1 tag:flag+1];
    [_socket readDataWithTimeout:-1 tag:flag];
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接到:%@",host);
    isConnected = true;
    [_socket readDataWithTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag+1];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"断开连接:%@,%@",sock.connectedHost,err);
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSLog(@"readData %@:,%@",sock.connectedHost,[[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding]);
    NSLog(@"readData %@:,%@",sock.connectedHost,data);
    const char *t_data = [data bytes];
    if ([_indicator isHidden] == NO) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
    
    if (flag+1 == tag && t_data[25] == 0x31 && t_data[26] == 0x08)
    {
        sFireware = (MyFireware*)t_data;
        int v,u=0;
        v = sFireware->fireware_version[0]%16*10+sFireware->fireware_version[1]%16;
        u = sFireware->fireware_version[2]%16*10+sFireware->fireware_version[3]%16;
        if(v > 0)
            _version.text = [[NSString alloc]initWithFormat:@"V%d.%d",v,u];
    }
    else if(flag == tag && t_data[25] == 0x31 && t_data[26] == 0x09)
    {
        sDevInfo = (MyDeviceInfo*)t_data;
        int day = ((sDevInfo->run_days[0] << 8 &0xFF) | (sDevInfo->run_days[1] &0xFF));
        if(day > 0)
            _days.text = [[NSString alloc]initWithFormat:@"%d天",day];
        int tmp = (sDevInfo->sys_temperature[1] &0xFF);
        if(tmp > 0)
            _temperature.text = [[NSString alloc]initWithFormat:@"%d摄氏度",tmp];
        int vol = (sDevInfo->voltage[0] &0xff);
        if(vol > 0 && vol < 20)
            _voltage.text = [[NSString alloc]initWithFormat:@"%d.%dV",(sDevInfo->voltage[0] &0xff),(sDevInfo->voltage[1]&0xff)];
        _runInfo.text = @"正常";
    }
   
}
@end
