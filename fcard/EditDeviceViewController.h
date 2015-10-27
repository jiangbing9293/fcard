//
//  EditDeviceViewController.h
//  FCARD
//
//  Created by FREELANCER on 14-7-2.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDevice.h"
#import "FMDatabase.h"

extern FMDatabase *database;

@interface EditDeviceViewController : UIViewController <UITextFieldDelegate,UIPickerViewDelegate>
{
    int channel;
    int rtsp;
    MyDevice *device;
}
@property (retain, nonatomic) IBOutlet UIButton *mBtnSubmit;
@property (nonatomic, retain) MyDevice *device;
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
