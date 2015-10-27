//
//  OpenDoorViewController.h
//  FCARD
//
//  Created by FREELANCER on 14-7-8.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDevice.h"
#import "GCDAsyncSocket.h"

extern MyDevice *device;

@interface OpenDoorViewController : UIViewController<GCDAsyncSocketDelegate, UIAlertViewDelegate>
{
    GCDAsyncSocket *socket;
}
@property (retain, nonatomic) IBOutlet UIButton *mBtn1;
@property (retain, nonatomic) IBOutlet UIButton *mBtn2;
@property (retain, nonatomic) IBOutlet UIButton *mBtn3;
@property (retain, nonatomic) IBOutlet UIButton *mBtn4;
@property (strong) GCDAsyncSocket *socket;
@property (nonatomic, retain) IBOutlet UILabel *m1;
@property (nonatomic, retain) IBOutlet UILabel *m2;
@property (nonatomic, retain) IBOutlet UILabel *m3;
@property (nonatomic, retain) IBOutlet UILabel *m4;
-(void)showDilog;
- (IBAction)back:(id)sender;
- (IBAction)opend1:(id)sender;
- (IBAction)opend2:(id)sender;
- (IBAction)opend3:(id)sender;
- (IBAction)opend4:(id)sender;
@end
