//
//  EditDeviceViewController.m
//  FCARD
//
//  Created by FREELANCER on 14-7-2.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "EditDeviceViewController.h"
#import "DeviceListViewController.h"
#import "freelancerAppDelegate.h"
#import "MyTool.h"

@implementation EditDeviceViewController

@synthesize dev_address = _dev_address;
@synthesize dev_port = _dev_port;
@synthesize dev_password = _dev_password;
@synthesize dev_sn = _dev_sn;
@synthesize cam_address =_cam_address;
@synthesize cam_port = _cam_port;
@synthesize cam_channel = _cam_channel;
@synthesize cam_acc = _cam_acc;
@synthesize cam_password = _cam_password;

@synthesize device = _device;

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
    channel = 0;
    rtsp = 2;
    if (_device != nil) {
        [_dev_address setText:_device.dev_address];
        [_dev_port setText:_device.dev_port];
        [_dev_password setText:_device.dev_password];
        [_dev_sn setText:_device.dev_sn];
        [_cam_address setText:_device.cam_address];
        [_cam_port setText:_device.cam_port];
        if (_device.rtsp == nil)
        {
            rtsp = 2;
        }
        else if(_device.rtsp)
        {
            rtsp = [_device.rtsp intValue];
        }
        
        if ([_device.channel isEqualToString:@"0"])
        {
            channel = 0;
            [_cam_channel setTitle:@"高清" forState:UIControlStateNormal];
        }
        else if ([_device.channel isEqualToString:@"1"])
        {
            channel = 1;
            [_cam_channel setTitle:@"标清" forState:UIControlStateNormal];
        }
        [_cam_acc setText:_device.view_acc];
        [_cam_password setText:_device.view_pwd];
        // 设置选择器
        CGFloat s_width = [UIScreen mainScreen].bounds.size.width;
        
        _pickerview = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0,360.0, s_width, 100.0)];
        _pickerview.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _pickerview.delegate = self;
        _pickerview.showsSelectionIndicator = YES;
        
        [self.view addSubview:_pickerview];
        [self.view bringSubviewToFront:_mBtnSubmit];
        [_pickerview selectRow:rtsp inComponent:0 animated:YES];

    }
}

- (void)dealloc
{
    [_mBtnSubmit release];
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
    [_device release];
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
- (IBAction)changeChannel:(id)sender
{
    if (channel == 1) {
        channel = 0;
        [_cam_channel setTitle:@"高清" forState:UIControlStateNormal];
    }
    else
    {
        channel = 1;
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
    else if([_dev_sn.text length] != 16){
        [MyTool showAlert:@"设备SN不合法（16位）"];
        return;
    }
    [_device setDev_address:[[NSString alloc] initWithFormat:@"%@", _dev_address.text!=nil?_dev_address.text:@""]];
    [_device setDev_port:[[NSString alloc] initWithFormat:@"%@", _dev_port.text!=nil?_dev_port.text:@""]];
    [_device setDev_password:[[NSString alloc] initWithFormat:@"%@", _dev_password.text!=nil?_dev_password.text:@""]];
    [_device setCam_address:[[NSString alloc] initWithFormat:@"%@", _cam_address.text!=nil?_cam_address.text:@""]];
    [_device setCam_port:[[NSString alloc] initWithFormat:@"%@", _cam_port.text!=nil?_cam_port.text:@""]];
    [_device setChannel:[[NSString alloc]initWithFormat:@"%d",channel]];
    [_device setView_acc:[[NSString alloc] initWithFormat:@"%@", _cam_acc.text!=nil?_cam_acc.text:@""]];
    [_device setView_pwd:[[NSString alloc] initWithFormat:@"%@", _cam_password.text!=nil?_cam_password.text:@""]];
    [_device setRtsp:[[NSString alloc] initWithFormat:@"%d",rtsp]];
    if (database != NULL)
    {
        if(![database executeUpdate:@"UPDATE device SET dev_address=?, dev_port=?, dev_password=?, cam_address=?, came_port=?, channel=?, view_acc=?, view_pwd=?, rtsp=? where dev_sn=?",
         _device.dev_address, _device.dev_port, _device.dev_password, _device.cam_address, _device.cam_port, _device.channel, _device.view_acc, _device.view_pwd,_device.rtsp,_device.dev_sn])
        {
             NSLog(@"Fail to update device to database.");
        }
    }
//    DeviceListViewController *back= [[DeviceListViewController alloc]initWithNibName:@"DeviceListViewController" bundle:nil];
//    [self presentViewController:back animated:YES completion:^(void){}];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
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
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 256.0);
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
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
    NSLog(@"result: %@",result);
    
}
@end
