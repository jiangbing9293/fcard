//
//  SetMonitorRateViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-11.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetMonitorRateViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *editRate;

-(IBAction)back:(id)sender;
- (IBAction)submit:(id)sender;
@end
