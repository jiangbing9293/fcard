//
//  OdpListViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "OdpListViewController.h"
#import "MainMenuViewController.h"
#import "EditOdpViewController.h"
#import "AddOdpViewController.h"
#import "OdpListTableViewCell.h"
#import "PacketStruct.h"
#import "MyTool.h"

@interface OdpListViewController ()
@end

@implementation OdpListViewController

@synthesize socket = _socket;
@synthesize tableView = _tableView;
@synthesize search = _search;

int flag;
MyOpenDoorPwdStruct mContents[100];

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
    searchDate = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    flag  =  arc4random() % 10000;
    memset(mContents, 0, 100);
    NSError *err = nil;
    if(![_socket connectToHost:device.dev_address onPort:[device.dev_port intValue] error:&err])
    {
        NSLog(@"%@",err.description);
    }else
    {
        NSLog(@"ok open port");
    }
    [_socket writeData:[MainMenuViewController getPacket:OPEN_DOOR_PWD_LIST_CONTROL data_length:OPEN_DOOR_PWD_LIST_DATELENGTH data:nil len:0] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag+1];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [searchDate removeAllObjects];
    [searchDate addObjectsFromArray:odp_list];
    [_tableView reloadData];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_socket disconnect];
}
- (void)dealloc
{
    [super dealloc];
    [_tableView release];
    [_search release];
    [_socket release];
    searchDate = nil;
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
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDate count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CardListCellIdentifier = @"OdpListCellIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"OdpListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CardListCellIdentifier];
        nibsRegistered = YES;
    }
    
    OdpListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CardListCellIdentifier];
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:@"OdpListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CardListCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CardListCellIdentifier];
    }
    
    
    NSUInteger row = [indexPath row];
    if([searchDate count] > 0 && row < [searchDate count])
    {
        MyOpenDoorPwd *odp = [searchDate objectAtIndex:row];
        cell.card_num = [MyTool getHiddle:[odp open_door_pwd]];
        cell.card_name = [odp info];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}
// 设置删除按钮标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置划动cell是否出现del按钮，可供删除数据里进行处理
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return true;
}
//设置选中Cell的响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    EditOdpViewController *edit_view = [[EditOdpViewController alloc]initWithNibName:@"EditOdpViewController" bundle:nil];
    edit_view.mOdp = [searchDate objectAtIndex:[indexPath row]];
    [self presentViewController:edit_view animated:YES completion:^(void){}];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
//    EditCardViewController *edit_view = [[EditCardViewController alloc]initWithNibName:@"EditCardViewController" bundle:nil];
//    edit_view.mCard = [searchDate objectAtIndex:[indexPath row]];
//    [self presentViewController:edit_view animated:YES completion:^(void){}];
//    [self.view removeFromSuperview];
//}

//设置删除时编辑状态
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *card_num;
    MyOpenDoorPwd *odp = [searchDate objectAtIndex: [indexPath row]];
    card_num = odp.open_door_pwd;
    
    char ADD_ODP_RIGHT[1] = {0};
    [MyTool str2bcd:ADD_CARD_PASSWORD str:card_num];
    NSMutableData *odp_data = [[NSMutableData alloc]init];
    [odp_data appendBytes:ADD_CARD_COUNT length:sizeof(ADD_CARD_COUNT)];
    [odp_data appendBytes:ADD_ODP_RIGHT length:sizeof(ADD_ODP_RIGHT)];
    [odp_data appendBytes:ADD_CARD_PASSWORD length:sizeof(ADD_CARD_PASSWORD)];
    
    [_socket writeData:[MainMenuViewController getPacket:OPEN_DOOR_PWD_DEL_CONTROL data_length:OPEN_DOOR_PWD_DATALENGTH data:[odp_data bytes] len:((int)[odp_data length])] withTimeout:-1 tag:flag];
    [_socket readDataWithTimeout:-1 tag:flag];
    
    if (database != NULL) {
        if (![database executeUpdate:@"DELETE FROM door_pwd where open_door_pwd=?", card_num]) {
            NSLog(@"Fail to remove card from database.");
        }
    }
    MyOpenDoorPwd *m = [searchDate objectAtIndex:[indexPath row]];
    [odp_list removeObject:m];
    [searchDate removeObjectAtIndex:[indexPath row]];
    [_tableView reloadData];
}

-(IBAction)addCard:(id)sender
{
    AddOdpViewController *add_view = [[AddOdpViewController alloc]initWithNibName:@"AddOdpViewController" bundle:nil];
    [self presentViewController:add_view animated:YES completion:^(void){}];
}
-(IBAction)back:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:^(void){}];
    MainMenuViewController *view = [[MainMenuViewController alloc]initWithNibName:@"MainMenuViewController" bundle:nil];
    [self presentViewController:view animated:YES completion:^(void){}];
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
- (IBAction)dateChanged:(id)sender
{
    [searchDate removeAllObjects];
    [_tableView reloadData];
    if ([_search.text isEqualToString:@""]) {
        [searchDate addObjectsFromArray:odp_list];
        [_tableView reloadData];
        return;
    }
    for (MyOpenDoorPwd *odp in odp_list) {
        NSRange range = [odp.open_door_pwd rangeOfString:_search.text];
        NSRange range1 = [odp.info rangeOfString:_search.text];
        if (range.length > 0 || range1.length > 0)
        {
            [searchDate addObject:odp];
            [_tableView reloadData];
        }
    }
    
}


-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接到:%@",host);
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
    if (flag == tag && t_data[25] == RESP && t_data[26] == RESP_OK) {
        [MyTool showAlert:@"删除成功"];
    }
    else if(flag+1 == tag && t_data[25]== 0x35 && t_data[26] == 0x03)
    {
        if (t_data[27] > 0x00) {
            return;
        }
        MyOpenDoorPwdListStruct *list = (MyOpenDoorPwdListStruct*)t_data;
        int len = [MyTool charsToInt:list->length];
        memcpy(mContents, (char*)list->mOdp, (len*5));
        for (int i = 0; i < len; ++i) {
            MyOpenDoorPwdStruct cont = mContents[i];
            BOOL has = NO;
            NSString *pwd = [MyTool bcd2str:cont.pwd];
            if ([pwd length] < 4) {
                continue;
            }
            for (MyOpenDoorPwd *odp in odp_list) {
                if([odp.open_door_pwd isEqualToString:pwd])
                {
                    has = YES;
                    break;
                }
            }
            if (has == NO)
            {
                int vilid = cont.vilid >> 4;
                NSString *str = [MyTool int2BinryStr:vilid];
                NSLog(@"%@,%@",pwd,str);
                MyOpenDoorPwd *odp = [[MyOpenDoorPwd alloc] initWithDevsn:device.dev_sn pwd:pwd info:@"未填写" M1:[str substringWithRange:NSMakeRange(0, 1)] M2:[str substringWithRange:NSMakeRange(1, 1)] M3:[str substringWithRange:NSMakeRange(2, 1)] M4:[str substringWithRange:NSMakeRange(3, 1)]];
                [odp_list addObject:odp];
                
                if (database != NULL)
                {
                    [database executeUpdate:@"INSERT INTO door_pwd(dev_sn, open_door_pwd,info, m1, m2,m3,m4) VALUES (?,?,?,?,?,?,?)",odp.dev_sn,odp.open_door_pwd,odp.info,odp.m1,odp.m2,odp.m3,odp.m4];
                }
                [odp release];
            }
        }
        [_socket writeData:[MainMenuViewController getPacket:OPEN_DOOR_PWD_LIST_CONTROL data_length:OPEN_DOOR_PWD_LIST_DATELENGTH data:nil len:0] withTimeout:-1 tag:flag];
        [_socket readDataWithTimeout:-1 tag:flag];
    }
    else if(t_data[25] == 0x21 && t_data[26] == RESP_ERROR_PWD)
    {
        [MyTool showAlert:@"通讯密码错误"];
    }
    else if(t_data[25] == 0x21 && t_data[26] == RESP_ERROR_CHECK)
    {
        [MyTool showAlert:@"校验出错"];
    }
}
@end
