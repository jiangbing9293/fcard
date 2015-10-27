//
//  SetQuestionViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetQuestionViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *question;
@property (nonatomic, retain) IBOutlet UITextField *answer;

- (IBAction)back:(id)sender;
- (IBAction)submit:(id)sender;

@end
