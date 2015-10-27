//
//  OdpListViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "MyOpenDoorPwd.h"
#import "MyDevice.h"

extern NSMutableArray *odp_list;
extern MyDevice *device;

@interface OdpListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,GCDAsyncSocketDelegate>
{
    NSMutableArray *searchDate;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong) GCDAsyncSocket *socket;

@property (nonatomic, retain) IBOutlet UITextField *search;

-(IBAction)addCard:(id)sender;
-(IBAction)back:(id)sender;
- (IBAction)dateChanged:(id)sender;

- (IBAction)TextField_DidEndOnExit:(id)sender;
- (IBAction)View_TouchDown:(id)sender;

@end
