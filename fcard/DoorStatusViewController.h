//
//  DoorStatusViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-3.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDevice.h"
#import "GCDAsyncSocket.h"

extern MyDevice *device;

@interface DoorStatusViewController : UIViewController<GCDAsyncSocketDelegate>

@property (strong) GCDAsyncSocket *socket;

@property (retain, nonatomic) IBOutlet UIView *mView1;
@property (retain, nonatomic) IBOutlet UIView *mView2;
@property (retain, nonatomic) IBOutlet UIView *mView3;
@property (retain, nonatomic) IBOutlet UIView *mView4;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

@property (nonatomic, retain) IBOutlet UILabel *m1;
@property (nonatomic, retain) IBOutlet UILabel *m1_switch;
@property (nonatomic, retain) IBOutlet UILabel *m1_alarm;
@property (nonatomic, retain) IBOutlet UILabel *m2;
@property (nonatomic, retain) IBOutlet UILabel *m2_switch;
@property (nonatomic, retain) IBOutlet UILabel *m2_alarm;
@property (nonatomic, retain) IBOutlet UILabel *m3;
@property (nonatomic, retain) IBOutlet UILabel *m3_switch;
@property (nonatomic, retain) IBOutlet UILabel *m3_alarm;
@property (nonatomic, retain) IBOutlet UILabel *m4;
@property (nonatomic, retain) IBOutlet UILabel *m4_switch;
@property (nonatomic, retain) IBOutlet UILabel *m4_alarm;

- (IBAction)back:(id)sender;
- (IBAction)refresh:(id)sender;
@end
