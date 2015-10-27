//
//  UpdatePasswordViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePasswordViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *old_pwd;
@property (nonatomic, retain) IBOutlet UITextField *n_pwd;
@property (nonatomic, retain) IBOutlet UITextField *submit_pwd;

- (IBAction)back:(id)sender;
- (IBAction)submit:(id)sender;

@end
