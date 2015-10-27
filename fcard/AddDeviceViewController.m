//
//  AddDeviceViewController.m
//  FCARD
//
//  Created by FREELANCER on 14-7-2.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "ChangeDoorNameViewController.h"
#import "freelancerAppDelegate.h"
#import "MyTool.h"
#import "MyDevice.h"

@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController

@synthesize dev_address = _dev_address;
@synthesize dev_port = _dev_port;
@synthesize dev_password = _dev_password;
@synthesize dev_sn = _dev_sn;
@synthesize cam_address =_cam_address;
@synthesize cam_port = _cam_port;
@synthesize cam_channel = _cam_channel;
@synthesize cam_acc = _cam_acc;
@synthesize cam_password = _cam_password;

NSArray *content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (content == nil) {
            content = [[NSArray alloc] initWithObjects:@"海康",@"大华",@"IPC",nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    channel = 1;
    rtsp = 2;
    // 设置选择器
    CGFloat s_width = [UIScreen mainScreen].bounds.size.width;
    
    _pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,360.0, s_width, 100.0)];
    _pickerview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _pickerview.delegate = self;
    _pickerview.showsSelectionIndicator = YES;
    
    [self.view addSubview:_pickerview];
    [self.view bringSubviewToFront:_btn_submit];
    [_pickerview selectRow:rtsp inComponent:0 animated:YES];
}

- (void)dealloc
{
    [_btn_submit release];
    [_txtRtsp release];
    [super dealloc];
    [_dev_address release];
    [_dev_port release];
    [_dev_password release];
    [_dev_sn release];
    [_cam_address release];
    [_cam_port release];
    [_cam_channel release];
    [_cam_acc release];
    [_cam_password release];
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField tag] == 100) {
        if (range.location >= 4)
            return NO; // return NO to not change text
    }
    if ([textField tag] == 102) {
        if (range.location >= 4)
            return NO; // return NO to not change text
    }
    if ([textField tag] == 101) {
        if (range.location >= 8)
            return NO; // return NO to not change text
    }
    if ([textField tag] == 103) {
        if (range.location >= 16)
            return NO; // return NO to not change text
    }
    return YES;
    
}
- (IBAction)changeChannel:(id)sender
{
    if (channel == 0) {
        channel = 1;
        [_cam_channel setTitle:@"高清" forState:UIControlStateNormal];
    }
    else if(channel == 1)
    {
        channel = 0;
        [_cam_channel setTitle:@"标清" forState:UIControlStateNormal];
    }
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

-(IBAction)submit:(id)sender
{
    if ([_dev_address.text isEqualToString:@""])
    {
        [MyTool showAlert:@"设备通信地址不能为空"];
        return;
    }
    if ([_dev_port.text isEqualToString:@""])
    {
        [MyTool showAlert:@"设备端口不能为空"];
        return;
    }
    if ([_dev_sn.text isEqualToString:@""])
    {
        [MyTool showAlert:@"设备SN不能为空"];
        return;
    }
    else if([MyTool isSnRight:_dev_sn.text] == NO){
        [MyTool showAlert:@"设备SN不合法"];
        return;
    }
    
    for (MyDevice *dev in device_list)
    {
        if ([_dev_sn.text isEqualToString:[dev dev_sn]]) {
            [MyTool showAlert:@"设备SN已存在"];
            return;
        }
    }
    
    MyDevice *_device = [[MyDevice alloc]init];
    [_device setDev_address:[[NSString alloc] initWithFormat:@"%@", _dev_address.text!=nil?_dev_address.text:@""]];
    [_device setDev_port:[[NSString alloc] initWithFormat:@"%@", _dev_port.text!=nil?_dev_port.text:@""]];
    [_device setDev_password:[[NSString alloc] initWithFormat:@"%@", _dev_password.text!=nil?_dev_password.text:@""]];
    [_device setDev_sn:[[NSString alloc] initWithFormat:@"%@", _dev_sn.text!=nil?_dev_sn.text:@""]];
    [_device setCam_address:[[NSString alloc] initWithFormat:@"%@", _cam_address.text!=nil?_cam_address.text:@""]];
    [_device setCam_port:[[NSString alloc] initWithFormat:@"%@", _cam_port.text!=nil?_cam_port.text:@""]];
    [_device setChannel:[[NSString alloc]initWithFormat:@"%d",channel]];
    [_device setView_acc:[[NSString alloc] initWithFormat:@"%@", _cam_acc.text!=nil?_cam_acc.text:@""]];
    [_device setView_pwd:[[NSString alloc] initWithFormat:@"%@", _cam_password.text!=nil?_cam_password.text:@""]];
    [_device setM1:[[NSString alloc] initWithFormat:@"%@", @"门1"]];
    [_device setM2:[[NSString alloc] initWithFormat:@"%@", @"门2"]];
    [_device setM3:[[NSString alloc] initWithFormat:@"%@", @"门3"]];
    [_device setM4:[[NSString alloc] initWithFormat:@"%@", @"门4"]];
    [_device setRtsp:[[NSString alloc] initWithFormat:@"%d", rtsp]];
    [device_list addObject:_device];
    if (database != NULL)
    {
        [database executeUpdate:@"INSERT INTO device(dev_address, dev_port, dev_password, dev_sn, cam_address, came_port, channel, view_acc, view_pwd, m1 , m2 , m3, m4, rtsp) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
         _device.dev_address, _device.dev_port, _device.dev_password, _device.dev_sn, _device.cam_address, _device.cam_port, _device.channel, _device.view_acc, _device.view_pwd, @"门1", @"门2", @"门3", @"门4",@"1"];
    }
    [_device release];
    UIViewController *dev_list = [[ChangeDoorNameViewController alloc]initWithNibName:@"ChangeDoorNameViewController" bundle:nil];
    [device setDev:_device];
    [self presentViewController:dev_list animated:YES completion:^(void){}];
    
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
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 256.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark 处理方法

// 返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
// 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (content == nil) {
        return 0;
    }
    return [content count];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0f;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)] autorelease];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [content objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    else
    {
        
        myView = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)] autorelease];
        
        myView.text = [content objectAtIndex:row];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.font = [UIFont systemFontOfSize:14];
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    myView.textColor = [UIColor whiteColor];
    return myView;
    
}
// 设置当前行的内容，若果行没有显示则自动释放
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (content == nil) {
        return @"";
    }
    pickerView.backgroundColor = [UIColor whiteColor];
    return [content objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString  *result = nil;
    
    result = [content objectAtIndex:row];
    rtsp = (int)row;
    _txtRtsp.text = result;
    
}
@end
