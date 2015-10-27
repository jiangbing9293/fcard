//
//  SecuritySettingViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-11.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"


@interface SecuritySettingViewController : UIViewController<GCDAsyncSocketDelegate,UIAlertViewDelegate>


@property (strong) GCDAsyncSocket *socket;
@property (retain, nonatomic) IBOutlet UIButton *btnStatus;
@property (retain, nonatomic) IBOutlet UITextField *editInDelayTime;
@property (retain, nonatomic) IBOutlet UITextField *editOutDelayTime;
@property (retain, nonatomic) IBOutlet UITextField *editSetPassword;
@property (retain, nonatomic) IBOutlet UITextField *editCancelPassword;
@property (retain, nonatomic) IBOutlet UITextField *editAlarmTime;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)changeStatus:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)submit:(id)sender;

@end
