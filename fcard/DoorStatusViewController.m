//
//  DoorStatusViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-3.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "DoorStatusViewController.h"
#import "PacketStruct.h"
#import "MainMenuViewController.h"
#import "MyTool.h"

@interface DoorStatusViewController ()

@end

@implementation DoorStatusViewController
@synthesize socket = _socket;
@synthesize indicator = _indicator;
@synthesize m1 = _m1;
@synthesize m1_switch = _m1_switch;
@synthesize m1_alarm = _m1_alarm;
@synthesize m2 = _m2;
@synthesize m2_switch = _m2_switch;
@synthesize m2_alarm = _m2_alarm;
@synthesize m3 = _m3;
@synthesize m3_switch = _m3_switch;
@synthesize m3_alarm = _m3_alarm;
@synthesize m4 = _m4;
@synthesize m4_switch = _m4_switch;
@synthesize m4_alarm = _m4_alarm;

int flag;
MyPortStatusInfo *port_status;
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
    port_status = malloc(sizeof(MyPortStatusInfo));
    memset(port_status, 0, sizeof(MyPortStatusInfo));
    if(DOORNUM == 1)
    {
        [_mView2 setHidden:YES];
        [_mView3 setHidden:YES];
        [_mView4 setHidden:YES];
    }
    else if(DOORNUM == 2)
    {
        [_mView3 setHidden:YES];
        [_mView4 setHidden:YES];
    }
    else{
        [_mView1 setHidden:NO];
        [_mView2 setHidden:NO];
        [_mView3 setHidden:NO];
        [_mView4 setHidden:NO];
    }
    [_indicator startAnimating];
    _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    flag  =  arc4random() % 10000;
    NSError *err = nil;
    if(![_socket connectToHost:device.dev_address onPort:[device.dev_port intValue] error:&err])
    {
        NSLog(@"%@",err.description);
        [_indicator stopAnimating];
        [MyTool showAlert:@"网络连接失败"];
    }else
    {
        NSLog(@"ok open port");
    }
    [_socket writeData:[MainMenuViewController getPacket:DOOR_STATUS_CONTROL data_length:DOOR_STATUS_DATALENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [self performSelectorInBackground:@selector(getConnectedTimeout) withObject:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _m1.text = device.m1;
    _m2.text = device.m2;
    _m3.text = device.m3;
    _m4.text = device.m4;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
    isStop = true;
}

-(void)dealloc
{
    [_mView1 release];
    [_mView2 release];
    [_mView3 release];
    [_mView4 release];
    [super dealloc];
    [_indicator release];
    [_m1 release];
    [_m1_switch release];
    [_m1_alarm release];
    [_m2 release];
    [_m2_switch release];
    [_m2_alarm release];
    [_m3 release];
    [_m3_switch release];
    [_m3_alarm release];
    [_m4 release];
    [_m4_switch release];
    [_m4_alarm release];
     [_socket release];
    free(port_status);
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

- (IBAction)refresh:(id)sender
{
    if ([_indicator isAnimating])
    {
        return;
    }
    if (isConnected == false) {
        [MyTool showAlert:@"网络未连接"];
        return;
    }
    [_indicator startAnimating];
    if (_socket != nil)
        [_socket writeData:[MainMenuViewController getPacket:DOOR_STATUS_CONTROL data_length:DOOR_STATUS_DATALENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag];
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
    port_status = (MyPortStatusInfo *)t_data;
    [self showSwitchStatus];
    [self showAlarmStatus];
}

-(void) showSwitchStatus
{
    if(port_status->door_switch[0] == 1)
    {
        _m1_switch.text = @"开";
    }
    else{
        _m1_switch.text = @"关";
    }
    if(port_status->door_switch[1] == 1)
    {
        _m2_switch.text = @"开";
    }
    else{
        _m2_switch.text = @"关";
    }
    if(port_status->door_switch[2] == 1)
    {
        _m3_switch.text = @"开";
    }
    else{
        _m3_switch.text = @"关";
    }
    if(port_status->door_switch[3] == 1)
    {
        _m4_switch.text = @"开";
    }
    else{
        _m4_switch.text = @"关";
    }

}
- (void) showAlarmStatus
{
    switch (port_status->door_alarm_status[0]) {
        case 0:
            _m1_alarm.text = @"无报警";
            break;
        case 1:
             _m1_alarm.text = @"非法刷卡报警";
            break;
        case 2:
             _m1_alarm.text = @"门磁报警";
            break;
        case 4:
             _m1_alarm.text = @"胁迫报警";
            break;
        case 8:
             _m1_alarm.text = @"开门超时报警";
            break;
        case 16:
             _m1_alarm.text = @"黑名单报警";
            break;
    }
    switch (port_status->door_alarm_status[1]) {
        case 0:
            _m2_alarm.text = @"无报警";
            break;
        case 1:
            _m2_alarm.text = @"非法刷卡报警";
            break;
        case 2:
            _m2_alarm.text = @"门磁报警";
            break;
        case 4:
            _m2_alarm.text = @"胁迫报警";
            break;
        case 8:
            _m2_alarm.text = @"开门超时报警";
            break;
        case 16:
            _m2_alarm.text = @"黑名单报警";
            break;
    }
    switch (port_status->door_alarm_status[2]) {
        case 0:
            _m3_alarm.text = @"无报警";
            break;
        case 1:
            _m3_alarm.text = @"非法刷卡报警";
            break;
        case 2:
            _m3_alarm.text = @"门磁报警";
            break;
        case 4:
            _m3_alarm.text = @"胁迫报警";
            break;
        case 8:
            _m3_alarm.text = @"开门超时报警";
            break;
        case 16:
            _m3_alarm.text = @"黑名单报警";
            break;
    }
    switch (port_status->door_alarm_status[3]) {
        case 0:
            _m4_alarm.text = @"无报警";
            break;
        case 1:
            _m4_alarm.text = @"非法刷卡报警";
            break;
        case 2:
            _m4_alarm.text = @"门磁报警";
            break;
        case 4:
            _m4_alarm.text = @"胁迫报警";
            break;
        case 8:
            _m4_alarm.text = @"开门超时报警";
            break;
        case 16:
            _m4_alarm.text = @"黑名单报警";
            break;
    }
}
@end
