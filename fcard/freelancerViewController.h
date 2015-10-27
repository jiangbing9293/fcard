//
//  freelancerViewController.h
//  FCARD
//
//  Created by FREELANCER on 14-6-25.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"

@interface freelancerViewController : UIViewController <GCDAsyncSocketDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
     NSString *savePwd;
}
@property (nonatomic, assign) NSString *savePwd;
@property (retain, nonatomic) IBOutlet UILabel *alert;
@property (nonatomic, retain) IBOutlet UITextField *pwd;

@property (retain, nonatomic) IBOutlet UILabel *txtVersion;
- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

-(IBAction)clk_find_pwd:(id)sender;
-(IBAction)clk_submit:(id)sender;
@end
