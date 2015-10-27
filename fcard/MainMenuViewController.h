//
//  MainMenuViewController.h
//  FCARD
//
//  Created by FREELANCER on 14-7-6.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDevice.h"
#import "MyOpenDoorPwd.h"
#define CONNECTED_TIME_OUT 30

extern MyDevice *device;
extern NSInteger DOORNUM;
extern NSMutableArray *odp_list;
@interface MainMenuViewController : UIViewController
{
}
@property (nonatomic, retain) IBOutlet UIScrollView *myScrollView;
+ (NSMutableData *) getPacket:(char*)con_code data_length:(char*)length data:(const char*)data len:(int)len;

- (IBAction)back:(id)sender;
-(IBAction)opendoorpwd:(id)sender;
- (IBAction)personnelfiles:(id)sender;
- (IBAction)doorstate:(id)sender;
- (IBAction)securitysetting:(id)sender;
- (IBAction)remotedoor:(id)sender;
- (IBAction)checkrecoords:(id)sender;
- (IBAction)datamonitoring:(id)sender;
- (IBAction)videosurveillance:(id)sender;
- (IBAction)nomenclature:(id)sender;
- (IBAction)setttingclock:(id)sender;
- (IBAction)deviceinformation:(id)sender;
- (IBAction)communications:(id)sender;
- (IBAction)systemsetting:(id)sender;
@end
