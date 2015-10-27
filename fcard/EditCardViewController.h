//
//  EditCardViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "MyDevice.h"
#import "GCDAsyncSocket.h"
#import "MyCard.h"

extern FMDatabase *database;
extern NSMutableArray *card_list;
extern MyDevice *device;
extern NSInteger DOORNUM;


@interface EditCardViewController : UIViewController<GCDAsyncSocketDelegate,UITextFieldDelegate>

@property (strong) GCDAsyncSocket *socket;
@property (nonatomic, retain) MyCard *mCard;

@property (nonatomic, retain) UIImage *clk;
@property (nonatomic, retain) UIImage *unclk;

@property (retain, nonatomic) IBOutlet UIButton *btnSelectDate;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) IBOutlet UITextField *card_num;
@property (nonatomic, retain) IBOutlet UITextField *card_name;
@property (nonatomic, retain) IBOutlet UITextField *card_tel;
@property (nonatomic, retain) IBOutlet UITextField *card_info;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indictor;

@property (nonatomic, retain) IBOutlet UILabel *m1;
@property (nonatomic, retain) IBOutlet UILabel *m2;
@property (nonatomic, retain) IBOutlet UILabel *m3;
@property (nonatomic, retain) IBOutlet UILabel *m4;

@property (nonatomic, retain) IBOutlet UIButton *btn1;
@property (nonatomic, retain) IBOutlet UIButton *btn2;
@property (nonatomic, retain) IBOutlet UIButton *btn3;
@property (nonatomic, retain) IBOutlet UIButton *btn4;

-(IBAction)showDatePicker:(id)sender;

-(IBAction)back:(id)sender;
-(IBAction)addCard:(id)sender;

- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

- (IBAction)bnt1_clk:(id)sender;
- (IBAction)bnt2_clk:(id)sender;
- (IBAction)bnt3_clk:(id)sender;
- (IBAction)bnt4_clk:(id)sender;
@end
