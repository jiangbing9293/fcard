//
//  ChangeDoorNameViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-7-31.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDevice.h"
#import "FMDatabase.h"

extern MyDevice *device;
extern FMDatabase *database;
extern NSInteger DOORNUM;

@interface ChangeDoorNameViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *ip;
@property (nonatomic, retain) IBOutlet UILabel *sn;
@property (nonatomic, retain) IBOutlet UITextField *m1;
@property (retain, nonatomic) IBOutlet UILabel *lbM1;
@property (nonatomic, retain) IBOutlet UITextField *m2;
@property (retain, nonatomic) IBOutlet UILabel *lbM2;
@property (nonatomic, retain) IBOutlet UITextField *m3;
@property (retain, nonatomic) IBOutlet UILabel *lbM3;
@property (nonatomic, retain) IBOutlet UITextField *m4;
@property (retain, nonatomic) IBOutlet UILabel *lbM4;

- (IBAction)back:(id)sender;
- (IBAction)submit:(id)sender;

- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

@end
