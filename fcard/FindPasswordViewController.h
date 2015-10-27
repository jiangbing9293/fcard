//
//  FindPasswordViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-6-29.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *pwd_question;
@property (nonatomic, retain) IBOutlet UITextField *pwd_answer;
@property (nonatomic, retain) IBOutlet UITextField *pwd_new;
@property (nonatomic, retain) IBOutlet UITextField *pwd_submit;

- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

-(IBAction)clk_back:(id)sender;
-(IBAction)clk_submit:(id)sender;
@end
