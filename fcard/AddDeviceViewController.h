//
//  AddDeviceViewController.h
//  FCARD
//
//  Created by FREELANCER on 14-7-2.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "MyDevice.h"

extern NSMutableArray *device_list;
extern FMDatabase *database;
extern MyDevice *device;

@interface AddDeviceViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate>
{
    int channel;
    int rtsp;
}
@property (retain, nonatomic) IBOutlet UITextField *txtRtsp;
@property (retain, nonatomic) IBOutlet UIButton *btn_submit;
@property (nonatomic, retain) IBOutlet UITextField *dev_address;
@property (nonatomic, retain) IBOutlet UITextField *dev_port;
@property (nonatomic, retain) IBOutlet UITextField *dev_password;
@property (nonatomic, retain) IBOutlet UITextField *dev_sn;
@property (nonatomic, retain) IBOutlet UITextField *cam_address;
@property (nonatomic, retain) IBOutlet UITextField *cam_port;
@property (nonatomic, retain) IBOutlet UIButton *cam_channel;
@property (nonatomic, retain) IBOutlet UITextField *cam_acc;
@property (nonatomic, retain) IBOutlet UITextField *cam_password;
@property (nonatomic, retain) UIPickerView *pickerview;
-(IBAction)back:(id)sender;
-(IBAction)submit:(id)sender;

- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;
- (IBAction)changeChannel:(id)sender;

@end
