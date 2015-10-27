//
//  DeviceListViewController.h
//  FCARD
//
//  Created by FREELANCER on 14-7-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "MyDevice.h"
extern NSMutableArray *device_list;
extern FMDatabase *database;
extern MyDevice *device;
@interface DeviceListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(IBAction)back:(id)sender;
-(IBAction)addDev:(id)sender;
@end
