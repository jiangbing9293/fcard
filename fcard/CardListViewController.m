//
//  CardListViewController.m
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "CardListViewController.h"
#import "MainMenuViewController.h"
#import "AddCardViewController.h"
#import "CardListTableViewCell.h"
#import "EditCardViewController.h"
#import "MyCard.h"
#import "PacketStruct.h"
#import "MyTool.h"

@interface CardListViewController ()

@end

@implementation CardListViewController

@synthesize socket = _socket;
@synthesize tableView = _tableView;
@synthesize search = _search;

int flag;
MyDevice *dev;

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
    dev = device;
    searchDate = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    flag  =  arc4random() % 10000;
    NSError *err = nil;
    if(![_socket connectToHost:device.dev_address onPort:[device.dev_port intValue] error:&err])
    {
        NSLog(@"%@",err.description);
    }else
    {
        NSLog(@"ok open port");
    }

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [searchDate removeAllObjects];
    [searchDate addObjectsFromArray:card_list];
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
    static NSString *CardListCellIdentifier = @"CardListCellIdentifier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"CardListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CardListCellIdentifier];
        nibsRegistered = YES;
    }
    
    CardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CardListCellIdentifier];
    if (!cell)
    {
        UINib *nib = [UINib nibWithNibName:@"CardListTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CardListCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CardListCellIdentifier];
    }
    
    
    NSUInteger row = [indexPath row];
    if([searchDate count] > 0 && row < [searchDate count])
    {
        MyCard *card = [searchDate objectAtIndex:row];
        cell.card_num = [card card_num];
        cell.card_name = [card card_name];
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
    EditCardViewController *edit_view = [[EditCardViewController alloc]initWithNibName:@"EditCardViewController" bundle:nil];
    edit_view.mCard = [searchDate objectAtIndex:[indexPath row]];
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
    MyCard *card = [searchDate objectAtIndex: [indexPath row]];
    card_num = card.card_num;
    char CARD_NUM[5];
    char data_length[] = {0x00,0x00,0x00,0x01};
    char del_data[9];
    long long num = [card_num longLongValue];
    [MyTool getCardNum:CARD_NUM Num:num];
    memcpy(del_data, data_length, sizeof(data_length));
    memcpy(del_data + sizeof(data_length), CARD_NUM, sizeof(CARD_NUM));
    [_socket writeData:[MainMenuViewController getPacket:DEL_CARD_CONTROL data_length:DEL_CARD_DATGALENGTH data:del_data len:sizeof(del_data)] withTimeout:-1 tag:flag];
    
    if (database != NULL) {
        if (![database executeUpdate:@"DELETE FROM card where card_num=?", card_num]) {
            NSLog(@"Fail to remove card from database.");
        }
    }
    MyCard *c = [searchDate objectAtIndex:[indexPath row]];
    [card_list removeObject:c];
    [searchDate removeObjectAtIndex:[indexPath row]];
    [_tableView reloadData];
}

-(IBAction)addCard:(id)sender
{
    AddCardViewController *add_view = [[AddCardViewController alloc]initWithNibName:@"AddCardViewController" bundle:nil];
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
        [searchDate addObjectsFromArray:card_list];
        [_tableView reloadData];
        return;
    }
    for (MyCard *card in card_list) {
        NSRange range = [card.card_num rangeOfString:_search.text];
        NSRange range1 = [card.card_name rangeOfString:_search.text];
        if (range.length > 0 || range1.length > 0)
        {
            [searchDate addObject:card];
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
    if (t_data[25] == RESP && t_data[26] == RESP_OK) {
        [MyTool showAlert:@"删除成功"];
    }else if(t_data[26] == RESP_ERROR_PWD)
    {
        [MyTool showAlert:@"通讯密码错误"];
    }
    else if(t_data[26] == RESP_ERROR_CHECK)
    {
        [MyTool showAlert:@"校验出错"];
    }
}
@end
