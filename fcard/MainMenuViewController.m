//
//  MainMenuViewController.m
//  FCARD
//
//  Created by FREELANCER on 14-7-6.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "MainMenuViewController.h"
#import "OpenDoorViewController.h"
#import "CardListViewController.h"
#import "SystemSettingViewController.h"
#import "EditDeviceViewController.h"
#import "ChangeDoorNameViewController.h"
#import "SettingClockViewController.h"
#import "DoorStatusViewController.h"
#import "DeviceInfoViewController.h"
#import "CheckRecordViewController.h"
#import "RecordMonitorViewController.h"
#import "SecuritySettingViewController.h"
#import "PacketStruct.h"
#import "LiveViewController.h"
#import "DeviceListViewController.h"
#import "OdpListViewController.h"
//#import "MyLiveViewController.h"

/**
 *@ 开门密码列表 
 **/
NSMutableArray *odp_list;
NSInteger DOORNUM;
char SN[16];
char PASSWORD[4];

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

@synthesize myScrollView = _myScrollView;

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
    odp_list = [[NSMutableArray alloc] init];
    dispatch_queue_t load_odp_list = dispatch_queue_create("load_odp_list", NULL);
    dispatch_async(load_odp_list, ^{
        [self loadOdpFromDatabase];
    });
    dispatch_release(load_odp_list);
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    [_myScrollView setContentSize:CGSizeMake(mWidth, 500.0f)];
    
    const char *s = [[device dev_sn] cStringUsingEncoding:NSASCIIStringEncoding];
    //    strcpy(SN, s);
//    if(SN[0] != 'F')
    if(s != nil)
    {
        memset(SN, 0, 16);
        memcpy(SN, s, 16);
    }
    DOORNUM = [[NSString stringWithFormat:@"%c" ,SN[5]] intValue];
    NSLog(@"%s,%s",SN,s);
    NSString *pwd = [[NSString alloc] initWithString:device.dev_password==nil?@"":device.dev_password];
    NSLog(@"dev_password:%@,%@",[device dev_password],pwd);

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
        NSString *four = [pwd substringToIndex:2];
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
        NSString *four = [pwd substringToIndex:1];
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
        NSString *thrid = [pwd substringToIndex:2];
        int t = [thrid intValue];
        PASSWORD[2] = (t/10)*16 + t%10;
        PASSWORD[3] =0xFf;
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
        NSString *thrid = [pwd substringToIndex:1];
        int t = [thrid intValue];
        PASSWORD[2] = (t%10)*16 + 0x0f;
        PASSWORD[3] =0xFf;
    }
    else
    {
        PASSWORD[0] = 0xff;
        PASSWORD[1] = 0xff;
        PASSWORD[2] = 0xff;
        PASSWORD[3] = 0xff;
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)dealloc
{
    [super dealloc];
    [_myScrollView release];
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
//    [self dismissViewControllerAnimated:YES completion:^(void){}];
    UIViewController *dev_list = [[DeviceListViewController alloc]initWithNibName:@"DeviceListViewController" bundle:nil];
    [self presentViewController:dev_list animated:YES completion:^(void){}];
}
//  开门密码
- (IBAction)opendoorpwd:(id)sender
{
    OdpListViewController *card_list = [[OdpListViewController alloc]initWithNibName:@"OdpListViewController" bundle:nil];
    [self presentViewController:card_list animated:YES completion:^(void){}];
}
// 人事档案
- (IBAction)personnelfiles:(id)sender
{
    CardListViewController *card_list = [[CardListViewController alloc]initWithNibName:@"CardListViewController" bundle:nil];
    [self presentViewController:card_list animated:YES completion:^(void){}];
}

//门口状态
- (IBAction)doorstate:(id)sender
{
    DoorStatusViewController *status = [[DoorStatusViewController alloc] initWithNibName:@"DoorStatusViewController" bundle:nil];
    [self presentViewController:status animated:YES completion:^(void){}];
}
//防盗设置
- (IBAction)securitysetting:(id)sender
{
    UIViewController *security = [[SecuritySettingViewController alloc]initWithNibName:@"SecuritySettingViewController" bundle:nil];
    [self presentViewController:security animated:YES completion:^(void){}];
}
//远程开门
- (IBAction)remotedoor:(id)sender
{
    UIViewController *remotedoor = [[OpenDoorViewController alloc]initWithNibName:@"OpenDoorViewController" bundle:nil];
    [self presentViewController:remotedoor animated:YES completion:^(void){}];
}
//查看纪录
- (IBAction)checkrecoords:(id)sender
{
    CheckRecordViewController *check = [[CheckRecordViewController alloc]initWithNibName:@"CheckRecordViewController" bundle:nil];
    [self presentViewController:check animated:YES completion:^(void){}];
}
//数据监控
- (IBAction)datamonitoring:(id)sender
{
    RecordMonitorViewController *monitor = [[RecordMonitorViewController alloc]initWithNibName:@"RecordMonitorViewController" bundle:nil];
    [self presentViewController:monitor animated:YES completion:^(void){}];
}
//视频监控
- (IBAction)videosurveillance:(id)sender
{
    NSString *path;
    int rtsp = [device.rtsp intValue];
    NSString *main_sub = @"";
    switch (rtsp) {
            /*海康rtsp*/
        case 0:
            if ([device.channel isEqualToString:@"0"]) {
                main_sub = @"main";
            }
            else if ([device.channel isEqualToString:@"1"])
            {
                main_sub = @"sub";
            }
            if (![device.cam_port isEqualToString:@""]) {
                path = @"rtsp://%@:%@@%@:%@/ch1/%@/av_stream";
                path = [[NSString alloc]initWithFormat:path,device.view_acc,device.view_pwd,device.cam_address,device.cam_port,main_sub];
            }
            else if(device.view_acc != nil && ![device.view_acc isEqualToString:@""])
            {
                path = @"rtsp://%@:%@@%@/ch1/%@/av_stream";
                path = [[NSString alloc]initWithFormat:path,device.view_acc,device.view_pwd,device.cam_address,device.cam_port,main_sub];
            }
            else if(device.view_acc == nil || [device.view_acc isEqualToString:@""]){
                path = @"rtsp://%@:554/video%@.sdp";
                path = [[NSString alloc]initWithFormat:path,device.cam_address,device.channel];
            }
            break;
            /* 英泽rtsp*/
        case 2:
            if (![device.cam_port isEqualToString:@""]) {
                path = @"rtsp://%@:%@/user=%@&password=%@&channel=1&stream=%@.sdp";
                path = [[NSString alloc]initWithFormat:path,device.cam_address,device.cam_port,device.view_acc,device.view_pwd,device.channel];
            }
            else if(device.view_acc != nil && ![device.view_acc isEqualToString:@""])
            {
                path = @"rtsp://%@/user=%@&password=%@&channel=1&stream=%@.sdp";
                path = [[NSString alloc]initWithFormat:path,device.cam_address,device.view_acc,device.view_pwd,device.channel];
            }
            else if(device.view_acc == nil || [device.view_acc isEqualToString:@""]){
                path = @"rtsp://%@:554/video%@.sdp";
                path = [[NSString alloc]initWithFormat:path,device.cam_address,device.channel];
            }
            break;
            /**大华rtsp*/
        case 1:
            if ([device.channel isEqualToString:@"0"]) {
                main_sub = @"main";
            }
            else if ([device.channel isEqualToString:@"1"])
            {
                main_sub = @"sub";
            }
            if (![device.cam_port isEqualToString:@""]) {
                path = @"rtsp://%@:%@@%@:%@/cam/realmonitor?channel=1&subtype=%@";
                path = [[NSString alloc]initWithFormat:path,device.view_acc,device.view_pwd,device.cam_address,device.cam_port,device.channel];
            }
            else if(device.view_acc != nil && ![device.view_acc isEqualToString:@""])
            {
                path = @"rtsp://%@:%@@%@/cam/realmonitor?channel=1&subtype=%@";
                path = [[NSString alloc]initWithFormat:path,device.view_acc,device.view_pwd,device.cam_address,device.cam_port,device.channel];
            }
            else if(device.view_acc == nil || [device.view_acc isEqualToString:@""]){
                path = @"rtsp://%@:554/video%@.sdp";
                path = [[NSString alloc]initWithFormat:path,device.cam_address,device.channel];
            }
            break;
            
        default:
            break;
    }
    
    /*else if(_dev.view_acc == nil && [_dev.view_acc isEqualToString:@"apple"]){
        MyLiveViewController *view = [[MyLiveViewController alloc]initWithNibName:@"MyLiveViewController" bundle:nil];
        [self presentViewController:view animated:YES completion:nil];
        return;
    }
    */
//    path = @"rtsp://192.168.1.130:554/video1.sdp";
//    path = @"rtsp://zeze08.vicp.net/user=admin&password=&channel=1&stream=1.sdp";
    LiveViewController *vc = [LiveViewController movieViewControllerWithContentPath:path
                                                                               parameters:nil
                                                                                     test:path];
    [self presentViewController:vc animated:YES completion:nil];
}
//门口命名
- (IBAction)nomenclature:(id)sender
{
    ChangeDoorNameViewController *doorName = [[ChangeDoorNameViewController alloc]initWithNibName:@"ChangeDoorNameViewController" bundle:nil];
    [self presentViewController:doorName animated:YES completion:^(void){}];

}
//设置时钟
- (IBAction)setttingclock:(id)sender
{
    SettingClockViewController *setDate = [[SettingClockViewController alloc]initWithNibName:@"SettingClockViewController" bundle:nil];
    [self presentViewController:setDate animated:YES completion:^(void){}];

}
//设备信息
- (IBAction)deviceinformation:(id)sender
{
    DeviceInfoViewController *info = [[DeviceInfoViewController alloc]initWithNibName:@"DeviceInfoViewController" bundle:nil];
    [self presentViewController:info animated:YES completion:^(void){}];
}
//通信设置
- (IBAction)communications:(id)sender
{
    EditDeviceViewController *edit_view = [[EditDeviceViewController alloc]initWithNibName:@"EditDeviceViewController" bundle:nil];
    edit_view.device = device;
    [self presentViewController:edit_view animated:YES completion:^(void){}];

}
//系统设置
- (IBAction)systemsetting:(id)sender
{
    UIViewController *system= [[SystemSettingViewController alloc]initWithNibName:@"SystemSettingViewController" bundle:nil];
    [self presentViewController:system animated:YES completion:^(void){}];

}

+ (NSMutableData *) getPacket:(char*)con_code data_length:(char*)length data:(const char*)data len:(int)len
{
    char check = 0;
    for (int i = 0; i < sizeof(SN); ++i) {
        check += SN[i];
    }
    for (int i = 0; i < sizeof(PASSWORD); ++i) {
        check += PASSWORD[i];
    }
    for (int i = 0; i < sizeof(INFO_CODE); ++i) {
        check += INFO_CODE[i];
    }
    for (int i = 0; i < 3; ++i) {
        check += con_code[i];
    }
    for (int i = 0; i < 4; ++i) {
        check += length[i];
    }
    for (int i = 0; i < len; ++i) {
        check += data[i];
    }
    char CHECK_CODE[] = {check};
    NSMutableData *sndData = [[NSMutableData alloc]init];
    [sndData appendBytes:FLAG length:sizeof(FLAG)];
    [sndData appendBytes:SN length:sizeof(SN)];
    [sndData appendBytes:PASSWORD length:sizeof(PASSWORD)];
    [sndData appendBytes:INFO_CODE length:sizeof(INFO_CODE)];
    [sndData appendBytes:con_code length:3];
    [sndData appendBytes:length length:4];
    if (len > 0)
        [sndData appendBytes:data length:len];
    [sndData appendBytes:CHECK_CODE length:sizeof(CHECK_CODE)];
    [sndData appendBytes:FLAG length:sizeof(FLAG)];
    return sndData;
}

- (void)loadOdpFromDatabase {
    
    if (database != NULL) {
        
        FMResultSet *rs = [database executeQuery:@"SELECT * FROM door_pwd WHERE dev_sn=?",device.dev_sn];
        while([rs next]) {
            NSString *dev_sn = [rs stringForColumn:@"dev_sn"];
            NSString *open_door_pwd = [rs stringForColumn:@"open_door_pwd"];
            NSString *info = [rs stringForColumn:@"info"];
            NSString *m1 = [rs stringForColumn:@"m1"];
            NSString *m2 = [rs stringForColumn:@"m2"];
            NSString *m3 = [rs stringForColumn:@"m3"];
            NSString *m4 = [rs stringForColumn:@"m4"];
            NSLog(@"Load door_pwd(%@, %@, ", dev_sn, open_door_pwd);
            
            MyOpenDoorPwd *opd = [[MyOpenDoorPwd alloc]initWithDevsn:dev_sn pwd:open_door_pwd info:info M1:m1 M2:m2 M3:m3 M4:m4];
            [odp_list addObject:opd];
            [opd release];
        }
        [rs close];
    }
}

@end
