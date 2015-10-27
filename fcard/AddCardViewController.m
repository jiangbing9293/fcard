//
//  AddCardViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "AddCardViewController.h"
#import "CardListViewController.h"
#import "MainMenuViewController.h"
#import "MyCard.h"
#import "MyTool.h"
#import "PacketStruct.h"

@interface AddCardViewController ()

@end

@implementation AddCardViewController

char vilid[4];
int flag;

@synthesize socket = _socket;
@synthesize clk = _clk;
@synthesize unclk = _unclk;

@synthesize card_num = _card_num;
@synthesize card_name = _card_name;
@synthesize card_tel = _card_tel;
@synthesize card_info = _card_info;

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
bool showPicker;
char ADD_CARD_VILID_DATE[5];
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
    [MyTool getVilidDate:ADD_CARD_VILID_DATE currentDate:nil];
    // UIDatePicker控件的常用方法  时间选择控件
    
    _datePicker = [[UIDatePicker alloc] init];
    CGFloat mWidth = [UIScreen mainScreen].bounds.size.width;
    _datePicker.frame = CGRectMake((mWidth/2-160), 0, 320, 300); // 设置显示的位置和大小
    _datePicker.date = [NSDate date]; // 设置初始时间
    // [oneDatePicker setDate:[NSDate dateWithTimeIntervalSinceNow:48 * 20 * 18] animated:YES]; // 设置时间，有动画效果
    _datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"]; // 设置时区，中国在东八区
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最小时间
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(10*365*24 * 60 * 60+(24*60*60))]; // 设置最大时间
    _datePicker.datePickerMode = UIDatePickerModeDate; // 设置样式
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.alpha = 0.9f;
    [_datePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    [self.view addSubview:_datePicker]; // 添加到View上
    _datePicker.hidden = YES;
    _datePicker.date = [NSDate dateWithTimeIntervalSinceNow:(10*365*24 * 60 * 60)];
    _btnSelectDate = [[UIButton alloc]init];
    [_btnSelectDate setFrame:CGRectMake((mWidth/2-100), (_m4.frame.origin.y+_m4.frame.size.height+10), 200.0f, 40.0f)];
    [_btnSelectDate setTitle:@"选择有效期" forState:UIControlStateNormal];
    [_btnSelectDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSelectDate];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
    isStop = true;
}

- (void) dealloc
{
    [_btnSelectDate release];
    [_datePicker release];
    [_mIndicator release];
    [super dealloc];
    [_card_num release];
    [_card_name release];
    [_card_tel release];
    [_card_info release];
    
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
    long long max = 4294967294;
    if ([_card_num.text isEqualToString:@""] || ([_card_num.text longLongValue] > max) ||([_card_num.text longLongValue] < 1)) {
        [MyTool showAlert:@"卡号不合法"];
        return;
    }
    NSLog(@"card num %lld",[_card_num.text longLongValue]);
    if([_card_tel.text isEqualToString:@""] == NO && ([_card_tel.text length]>8 || [_card_tel.text length] < 5))
    {
        [MyTool showAlert:@"密码为5-8位数字"];
        return;
    }
    if ([_card_name.text isEqualToString:@""] || [_card_name.text length] > 15) {
        [MyTool showAlert:@"姓名非法"];
        return;
    }
    for (MyCard *card in card_list) {
        if([_card_num.text isEqualToString:card.card_num])
        {
            [MyTool showAlert:@"添加的卡号已存在"];
            return;
        }
    }
    char ADD_CARD_NUM[5];
   
    char ADD_CARD_RIGHT[1];
    
    long long num = [_card_num.text longLongValue];
    [MyTool getCardNum:ADD_CARD_NUM Num:num];
    ADD_CARD_RIGHT[0] = [self getVilid];
    [MyTool str2bcd:ADD_CARD_PASSWORD str:_card_tel.text];
    NSMutableData *card_data = [[NSMutableData alloc]init];
    [card_data appendBytes:ADD_CARD_COUNT length:sizeof(ADD_CARD_COUNT)];
    [card_data appendBytes:ADD_CARD_NUM length:sizeof(ADD_CARD_NUM)];
    [card_data appendBytes:ADD_CARD_PASSWORD length:sizeof(ADD_CARD_PASSWORD)];
    [card_data appendBytes:ADD_CARD_VILID_DATE length:sizeof(ADD_CARD_VILID_DATE)];
    [card_data appendBytes:ADD_CRAD_OPEN_TIME length:sizeof(ADD_CRAD_OPEN_TIME)];
    [card_data appendBytes:ADD_CARD_VILID_TIMES length:sizeof(ADD_CARD_VILID_TIMES)];
    [card_data appendBytes:ADD_CARD_RIGHT length:sizeof(ADD_CARD_RIGHT)];
    [card_data appendBytes:ADD_CARD_STATUS length:sizeof(ADD_CARD_STATUS)];
    [card_data appendBytes:ADD_CARD_HOLIDAY length:sizeof(ADD_CARD_HOLIDAY)];
    [card_data appendBytes:ADD_CARD_OI_FLAG length:sizeof(ADD_CARD_OI_FLAG)];
    [card_data appendBytes:ADD_CARD_RECREAD_DATE length:sizeof(ADD_CARD_RECREAD_DATE)];
    [_mIndicator setHidden:NO];
    [_socket writeData:[MainMenuViewController getPacket:ADD_CARD_CONTROL data_length:ADD_CRAD_DATALENGTH data:[card_data bytes] len:((int)[card_data length])] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag];
    
    MyCard *card = [[MyCard alloc]initWith:_card_num.text cardName:_card_name.text cardTel:_card_tel.text cardInfo:_card_info.text];;
    [card_list addObject:card];
    [card release];
    if (database != NULL)
    {
        [database executeUpdate:@"INSERT INTO card(card_num, card_name, card_tel, card_info) VALUES (?,?,?,?)",_card_num.text,_card_name.text, (_card_tel.text!=nil?_card_tel.text:@""), (_card_info.text!=nil?_card_info.text:@"")];
    }
    
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
//获取权限
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
    [_mIndicator setHidden:YES];
    const char *t_data = [data bytes];
    if (t_data[25] == RESP && t_data[26] == RESP_OK)
    {
        [MyTool showAlert:@"授权成功"];
        CardListViewController *card_list = [[CardListViewController alloc]initWithNibName:@"CardListViewController" bundle:nil];
        [self presentViewController:card_list animated:YES completion:^(void){}];
    }
    else if(t_data[26] == RESP_ERROR_PWD)
    {
        [MyTool showAlert:@"通讯密码错误"];
    }
    else if(t_data[26] == RESP_ERROR_CHECK)
    {
        [MyTool showAlert:@"校验出错"];
    }else if(t_data[25] == 0x37)
    {
        [MyTool showAlert:@"新增失败"];
    }
}

#pragma mark - 实现oneDatePicker的监听方法
-(IBAction)showDatePicker:(id)sender
{
    if (_datePicker.isHidden)
    {
        _datePicker.hidden = NO;
        [_btnSelectDate setTitle:@"确定" forState:UIControlStateNormal];
    }
    else{
        _datePicker.hidden = YES;
        [_btnSelectDate setTitle:@"选择有效期" forState:UIControlStateNormal];
    }
}
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyMMddHHmm"; // 设置时间和日期的格式
    NSString *current = [selectDateFormatter stringFromDate:select];
    current = [current stringByReplacingCharactersInRange:NSMakeRange(6, 4)withString:@"2359"];
    NSLog(@"current:%@",current);
    [MyTool getVilidDate:ADD_CARD_VILID_DATE currentDate:current];
}
@end
