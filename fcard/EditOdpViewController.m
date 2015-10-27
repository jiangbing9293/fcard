//
//  EditCardViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "EditOdpViewController.h"
#import "OdpListViewController.h"
#import "MainMenuViewController.h"
#import "MyOpenDoorPwd.h"
#import "MyTool.h"
#import "PacketStruct.h"

@interface EditOdpViewController ()

@end

@implementation EditOdpViewController

char vilid[4];
int flag;

@synthesize socket = _socket;
@synthesize clk = _clk;
@synthesize unclk = _unclk;

@synthesize card_num = _card_num;
@synthesize card_name = _card_name;

@synthesize m1 = _m1;
@synthesize m2 = _m2;
@synthesize m3 = _m3;
@synthesize m4 = _m4;

@synthesize btn1 = _btn1;
@synthesize btn2 = _btn2;
@synthesize btn3 = _btn3;
@synthesize btn4 = _btn4;
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
            [_mIndicator setHidden:YES];
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
        _clk = [UIImage imageNamed:@"addcard_imageview_on.png"];
        
        _unclk = [UIImage imageNamed:@"addcard_imageview_off.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isConnected = false;
    isStop = false;
    if(DOORNUM == 1)
    {
        [_btn2 setHidden:YES];
        [_btn3 setHidden:YES];
        [_btn4 setHidden:YES];
        
        [_m2 setHidden:YES];
        [_m3 setHidden:YES];
        [_m4 setHidden:YES];
    }
    else if(DOORNUM == 2)
    {
        [_btn3 setHidden:YES];
        [_btn4 setHidden:YES];
        
        [_m3 setHidden:YES];
        [_m4 setHidden:YES];
    }

    memset(vilid, 0, sizeof(vilid));
    _m1.text = device.m1;
    _m2.text = device.m2;
    _m3.text = device.m3;
    _m4.text = device.m4;
    [self initPwdVilid];
    [_mIndicator setHidden:YES];
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
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
    isStop = true;
}

- (void) dealloc
{
    [_mIndicator release];
    [super dealloc];
    [_card_num release];
    [_card_name release];
    
    [_m1 release];
    [_m2 release];
    [_m3 release];
    [_m4 release];
    
    [_btn1 release];
    [_btn2 release];
    [_btn3 release];
    [_btn4 release];
    
    [_clk release];
    [_unclk release];
    [_socket release];
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
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}
-(IBAction)addCard:(id)sender
{
//    NSLog(@"card num %lld",[_card_num.text longLongValue]);
//    if([_card_num.text isEqualToString:@""] == NO && ([_card_num.text length]>8 || [_card_num.text length] < 4))
//    {
//        [MyTool showAlert:@"密码为4-8位数字"];
//        return;
//    }
   
//    for (MyOpenDoorPwd *odp in odp_list) {
//        if([_card_num.text isEqualToString:odp.open_door_pwd])
//        {
//            [MyTool showAlert:@"添加的密码已存在"];
//            return;
//        }
//    }
   
    char ADD_ODP_RIGHT[1] = {0};
    ADD_ODP_RIGHT[0] = [self getVilid];
    [MyTool str2bcd:ADD_CARD_PASSWORD str:_mOdp.open_door_pwd];
    NSMutableData *odp_data = [[NSMutableData alloc]init];
    [odp_data appendBytes:ADD_CARD_COUNT length:sizeof(ADD_CARD_COUNT)];
    [odp_data appendBytes:ADD_ODP_RIGHT length:sizeof(ADD_ODP_RIGHT)];
    [odp_data appendBytes:ADD_CARD_PASSWORD length:sizeof(ADD_CARD_PASSWORD)];
    [_mIndicator setHidden:NO];
    [_mIndicator startAnimating];
    [_socket writeData:[MainMenuViewController getPacket:OPEN_DOOR_PWD_CONTROL data_length:OPEN_DOOR_PWD_DATALENGTH data:[odp_data bytes] len:((int)[odp_data length])] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag];
    
    MyOpenDoorPwd *odp = [[MyOpenDoorPwd alloc]initWithDevsn:device.dev_sn pwd:_card_num.text info:_card_name.text M1:[NSString stringWithFormat:@"%d",vilid[0]] M2:[NSString stringWithFormat:@"%d",vilid[1]] M3:[NSString stringWithFormat:@"%d",vilid[2]] M4:[NSString stringWithFormat:@"%d",vilid[3]]];
    
    [_mOdp setOdp:odp];
    if (database != NULL)
    {
        [database executeUpdate:@"UPDATE door_pwd SET info=?, m1=?, m2=?,m3=?,m4=?",odp.info,odp.m1,odp.m2,odp.m3,odp.m4];
    }
    [odp release];
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
    if ([textField tag] == 100) {
        if (range.location >= 10)
            return NO; // return NO to not change text
    }
    
    return YES;
    
}
- (IBAction)bnt1_clk:(id)sender
{
    if (vilid[0] == 0)
    {
        vilid[0] = 1;
    }
    else
    {
        vilid[0] = 0;
    }
    
    if (vilid[0] == 0) {
        [_btn1 setImage:[UIImage imageNamed:@"addcard_imageview_off.png"] forState:UIControlStateNormal];
    }else
    {
        [_btn1 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)bnt2_clk:(id)sender
{
    if (vilid[1] == 0)
    {
        vilid[1] = 1;
    }
    else
    {
        vilid[1] = 0;
    }
    
    if (vilid[1] == 0) {
        [_btn2 setImage:[UIImage imageNamed:@"addcard_imageview_off.png"] forState:UIControlStateNormal];
    }else
    {
        [_btn2 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)bnt3_clk:(id)sender
{
    if (vilid[2] == 0)
    {
        vilid[2] = 1;
    }
    else
    {
        vilid[2] = 0;
    }
    
    if (vilid[2] == 0) {
        [_btn3 setImage:[UIImage imageNamed:@"addcard_imageview_off.png"] forState:UIControlStateNormal];
    }else
    {
        [_btn3 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)bnt4_clk:(id)sender
{
    if (vilid[3] == 0)
    {
        vilid[3] = 1;
    }
    else
    {
        vilid[3] = 0;
    }
    if (vilid[3] == 0) {
        [_btn4 setImage:[UIImage imageNamed:@"addcard_imageview_off.png"] forState:UIControlStateNormal];
    }else
    {
        [_btn4 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
    }
}
/**
 @初始化密码权限
*/
 -(void)initPwdVilid
{
    if (_mOdp) {
        
        if ([_mOdp.m1 isEqualToString:@"1"]) {
            vilid[0] = 1;
            [_btn1 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
        }
        if ([_mOdp.m2 isEqualToString:@"1"]) {
             vilid[1] = 1;
            [_btn2 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
        }
        if ([_mOdp.m3 isEqualToString:@"1"]) {
             vilid[2] = 1;
            [_btn3 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
        }
        if ([_mOdp.m4 isEqualToString:@"1"]) {
             vilid[3] = 1;
            [_btn4 setImage:[UIImage imageNamed:@"addcard_imageview_on.png"] forState:UIControlStateNormal];
        }
        _card_name.text = _mOdp.info;
        _card_num.text = [MyTool getHiddle:[_mOdp open_door_pwd]];
    }
}
/**
 *@获取权限
 */
- (int)getVilid
{
    int v = 0;
    v += vilid[3]*8;
    v += vilid[2]*4;
    v += vilid[1]*2;
    v += vilid[0];
    v = v * 16;
    return v;
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
    [_mIndicator stopAnimating];
    [_mIndicator setHidden:YES];
    const char *t_data = [data bytes];
    if (t_data[25] == RESP && t_data[26] == RESP_OK)
    {
        [MyTool showAlert:@"修改成功"];
        OdpListViewController *card_list = [[OdpListViewController alloc]initWithNibName:@"OdpListViewController" bundle:nil];
        [self presentViewController:card_list animated:YES completion:^(void){}];
    }
    else if(t_data[26] == RESP_ERROR_PWD)
    {
        [MyTool showAlert:@"通讯密码错误"];
    }
    else if(t_data[26] == RESP_ERROR_CHECK)
    {
        [MyTool showAlert:@"校验出错"];
    }else if(t_data[25] == 0x35)
    {
        [MyTool showAlert:@"修改失败"];
    }
}

@end
