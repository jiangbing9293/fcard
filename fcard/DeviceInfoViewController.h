//
//  DeviceInfoViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-3.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDevice.h"
#import "GCDAsyncSocket.h"

@interface DeviceInfoViewController : UIViewController<GCDAsyncSocketDelegate>

@property (strong) GCDAsyncSocket *socket;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UILabel *version;
@property (nonatomic, retain) IBOutlet UILabel *days;
@property (nonatomic, retain) IBOutlet UILabel *temperature;
@property (nonatomic, retain) IBOutlet UILabel *voltage;
@property (nonatomic, retain) IBOutlet UILabel *runInfo;

- (IBAction)back:(id)sender;
- (IBAction)refresh:(id)sender;

@end
