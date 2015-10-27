//
//  SettingClockViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-3.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDevice.h"
#import "GCDAsyncSocket.h"

extern MyDevice *device;

@interface SettingClockViewController : UIViewController<GCDAsyncSocketDelegate>

@property (strong) GCDAsyncSocket *socket;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UILabel *ip;
@property (nonatomic, retain) IBOutlet UILabel *sn;
@property (nonatomic, retain) IBOutlet UITextField *dev_date;
@property (nonatomic, retain) IBOutlet UITextField *phone_date;

- (IBAction)back:(id)sender;
- (IBAction)updateDate:(id)sender;
- (IBAction)refresh:(id)sender;

@end
