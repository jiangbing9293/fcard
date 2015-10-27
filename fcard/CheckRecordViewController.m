//
//  CheckRecordViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-8-6.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "CheckRecordViewController.h"
#import "MainMenuViewController.h"
#import "MyTool.h"
#import "MyCard.h"
#import "PacketStruct.h"

@interface CheckRecordViewController ()

@end

@implementation CheckRecordViewController

@synthesize socket = _socket;

MyRecordPointerStruct *sRecordPointer;
MyRecordInfoStruct *sRead;

MyRecordContentStruct sContent[10];

int flag;
int recordCount;
int curentpage;
int pageCount;
int maxPage;
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
            [_indictor setHidden:YES];
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
    
    recordCount = 0;
    pageCount = 10;
    curentpage = 1;
    isConnected = false;
    isStop = false;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    sRecordPointer = malloc(sizeof(MyRecordPointerStruct));
    memset(sRecordPointer, 0, sizeof(MyRecordPointerStruct));
    
    sRead = malloc(sizeof(MyRecordInfoStruct));
    memset(sRead, 0, sizeof(MyRecordInfoStruct));
    
    memset(sContent, 0, sizeof(sContent));
    
    _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    flag  =  arc4random() % 10000;
    NSError *err = nil;
    if(![_socket connectToHost:device.dev_address onPort:[device.dev_port intValue] error:&err])
    {
        NSLog(@"%@",err.description);
        [MyTool showAlert:@"网络连接失败"];
    }
    else
    {
        NSLog(@"ok open port");
    }
    [_socket writeData:[MainMenuViewController getPacket:CHECK_RECORD_POINTER_CONTROL data_length:CHECK_RECORD_POINTER_DATALENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [self performSelectorInBackground:@selector(getConnectedTimeout) withObject:nil];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableView reloadData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
    isStop = true;
    
}
- (void)dealloc
{
    [_tableView release];
    [_tableViewCell release];
    [_indictor release];
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [_tableView reloadData];
//    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return NO;
}

#pragma TableView
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if((recordCount - (curentpage-1)*pageCount) < pageCount)
        return (recordCount % pageCount);
    return pageCount;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]init];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckRecordHeader" owner:self options:nil];
    
    if ([nib count] > 0)
        header = [nib objectAtIndex:0];
    return header;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    static NSString *RecordListCellIdentifier = @"RecordListCellIdentifier";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:RecordListCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CheckRecordCell" owner:self options:nil];
        
        if ([nib count] > 0)
            cell = [nib objectAtIndex:0];
    }
    
    UILabel *cardNum = (UILabel*)[cell viewWithTag:1];
    UILabel *date = (UILabel*)[cell viewWithTag:2];
    UILabel *readerNum = (UILabel*)[cell viewWithTag:3];
    UILabel *events = (UILabel*)[cell viewWithTag:4];
    UILabel *inOrOut = (UILabel*)[cell viewWithTag:5];
  
    MyRecordContentStruct cont;
    if (curentpage == maxPage) {
        cont = sContent[(recordCount%pageCount-1-row)];

    }
    else
    {
        cont = sContent[(pageCount-1-row)];
    }
    if (cardNum != nil)
    {
        NSString *card_num = [NSString stringWithFormat:@"%d",[MyTool charsToIntForCardNum:cont.record_card_num]];
        cardNum.text = [MyTool getNameByID:card_num];
        if((cont.record_status == 2) || (cont.record_status == 17) || (cont.record_status == 20) \
           || (cont.record_status == 27) || (cont.record_status == 28) || (cont.record_status == 30)\
           || (cont.record_status == 35) || (cont.record_status == 37))
        {
            cardNum.text = [MyTool bcd2str:cont.record_card_num];
        }
    }
    if (date != nil)
    {
        date.text = [NSString stringWithFormat:@"%@",[MyTool recordDateToDate:cont.record_date]];
    }
    if (readerNum != nil)
    {
        readerNum.text = [NSString stringWithFormat:@"%@",[self getDoorName:cont.record_reader_index]];
    }
    if (events != nil)
    {
        events.text = [NSString stringWithFormat:@"%@",[self getStatus:cont.record_status]];
    }
    if (inOrOut !=nil)
    {
        inOrOut.text = @"进门";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str;
    NSInteger row = [indexPath row];
    if (curentpage == maxPage) {
        str = [NSString stringWithFormat:@"%d",[MyTool charsToIntForCardNum:sContent[recordCount%pageCount-row-1].record_card_num]];
    }
    else{
        str = [NSString stringWithFormat:@"%d",[MyTool charsToIntForCardNum:sContent[pageCount-row-1].record_card_num]];
    }

    for (MyCard *card in card_list) {
        if ([card.card_num isEqualToString:str])
        {
            [MyTool showAlert:[NSString stringWithFormat:@"卡号：%@,姓名:%@,备注：%@",card.card_num ,card.card_name,card.card_info]];
            return;
        }
    }
   
        [MyTool showAlert:[NSString stringWithFormat:@"卡号：%@ ,未添加",str]];
        
        MyCard *card = [[MyCard alloc]initWith:str cardName:@"未填写" cardTel:@"" cardInfo:@"备注"];
        [card_list addObject:card];
        // [card release];
        if (database != NULL)
        {
            if (str != nil) {
                if (![database executeUpdate:@"INSERT INTO card(card_num, card_name, card_tel, card_info) VALUES(?,?,?,?)",
                      str, @"未填写", @"", @"备注"]) {
                    NSLog(@"add card %@ to database fail ",str);
                }
            }
            
        }
}
- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (IBAction)refresh:(id)sender
{
    if (isConnected == false) {
        [MyTool showAlert:@"网络未连接"];
        return;
    }
    [_socket writeData:[MainMenuViewController getPacket:CHECK_RECORD_POINTER_CONTROL data_length:CHECK_RECORD_POINTER_DATALENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag];
    curentpage = 1;
    [_indictor startAnimating];
}
-(IBAction)goToFirstPage:(id)sender
{
    curentpage = 1;
    [self search:curentpage];
}
-(IBAction)goToPrePage:(id)sender
{
    if (curentpage == 1) {
        [MyTool showAlert:@"已是第一页"];
        curentpage = 1;
        return;
    }
    --curentpage;
    [self search:curentpage];
}
- (IBAction)geToNextPage:(id)sender
{
    if (curentpage == maxPage) {
        [MyTool showAlert:@"数据见底了"];
        curentpage = maxPage;
        return;
    }
    ++curentpage;
    [self search:curentpage];
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
    if (tag == flag && t_data[25] == 0x38 && t_data[26]==1 && t_data[27]==0) {
        sRecordPointer = (MyRecordPointerStruct*)t_data;
        sRead = (MyRecordInfoStruct*)sRecordPointer->read_card_record;
        recordCount = [MyTool charsToInt: sRead->record_num];
        if (recordCount % pageCount == 0) {
             maxPage = recordCount/pageCount;
        }
        else
        {
            maxPage = recordCount/pageCount + 1;
        }
        [self search:curentpage];
    }
    else if(tag == flag +1 && t_data[25] == 0x38 && t_data[26]==4 && t_data[27] == 0x00)
    {
        MyRecordFormatSrtuct *sRecordFormat = (MyRecordFormatSrtuct*)t_data;
        memcpy(sContent, sRecordFormat->content, sizeof(sContent));
        for (int i = 0; i < 10; ++i) {
            MyRecordContentStruct cont = sContent[i];
            NSLog(@"=========%d, %d, %@",i,cont.record_status,[MyTool recordDateToDate:cont.record_date]);
        }
        [_socket readDataWithTimeout:-1 tag:flag+1];
    }
    
    NSLog(@"==== recordCount=%d",recordCount);
    dispatch_async(dispatch_get_main_queue(), ^(void){
         [_indictor stopAnimating];
        [_tableView reloadData];
        if (recordCount == 0) {
            [MyTool showAlert:@"提示" msg:@"暂无纪录!"];
        }
    });
}
- (void) search:(int)page
{
    char code[] = {0x01};
    char index[4];
    char readCount[4];
    NSMutableData *data = [[NSMutableData alloc]init];
    
    [_indictor startAnimating];
    if(page < maxPage && page > 0)
    {
        [MyTool intToChars:(recordCount -page * pageCount+1) chars:index];
        [MyTool intToChars:pageCount chars:readCount];
        
        [data appendBytes:code length:1];
        [data appendBytes:index length:4];
        [data appendBytes:readCount length:4];
       
        [_socket writeData:[MainMenuViewController getPacket:CHECK_RECORD_CONTROL data_length:CHECK_RECORD_DATALENGTH data:[data bytes] len:9] withTimeout:-1 tag:flag+1];
         [_socket readDataWithTimeout:-1 tag:flag+1];
    }
    else if(page == maxPage)
    {
        [MyTool intToChars:0 chars:index];
        [MyTool intToChars:(recordCount % pageCount) chars:readCount];
        
        [data appendBytes:code length:1];
        [data appendBytes:index length:4];
        [data appendBytes:readCount length:4];
        [_socket writeData:[MainMenuViewController getPacket:CHECK_RECORD_CONTROL data_length:CHECK_RECORD_DATALENGTH data:[data bytes] len:9] withTimeout:-1 tag:flag+1];
        [_socket readDataWithTimeout:-1 tag:flag+1];
    }
}

- (NSString *)getDoorName:(int)index
{
    if (index <= 2) {
        return device.m1;
    }
    else if (index <= 4) {
        return device.m2;
    }
    else if (index <= 6) {
        return device.m3;
    }
    else if (index <= 8) {
        return device.m4;
    }
    return @"";
}

- (NSString *)getStatus:(int)status
{
    NSArray *status_array = [[NSArray alloc] initWithObjects:@"",
                             @"合法开门",@"密码开门",@"卡加密码",@"手动卡加密码",
                             @"首卡开门",@"门常开",@"多卡开门",
                             @"重复读卡",@"过期卡",@"时段过期",
                             @"假日无效",@"非法卡",@"巡更卡",
                             @"探测锁定",@"无有效次数",@"防潜回",
                             @"密码错误",@"加卡错误",@"锁定开门",
                             @"首卡未开门",@"挂失卡",@"黑名单卡",
                             @"上限禁入",@"开启防盗(卡)",@"关闭防盗(卡)",
                             @"开启防盗(密码)",@"关闭防盗(密码)",@"互锁开门"
                             ,@"互锁(密码开门)",@"全卡开门",@"多卡开门",
                             @"多卡开门(组合错误)",@"刷卡无效",@"密码无效",
                             @"禁止刷卡开门",@"禁止密码开门",nil];
    if (status >= [status_array count]) {
        return @"其他";
    }
    return [status_array objectAtIndex:status];
}
@end
