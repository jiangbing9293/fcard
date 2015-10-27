//
//  RecordMonitorViewController.h
//  FCARD
//
//  Created by Qu Shutang on 14-8-11.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "MyDevice.h"
#import "FMDatabase.h"

extern FMDatabase *database;
extern MyDevice *device;
extern NSMutableArray *card_list;

@interface RecordMonitorViewController : UIViewController<GCDAsyncSocketDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong) GCDAsyncSocket *socket;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UILabel *mTitle;
@property (retain, nonatomic) IBOutlet UITableViewCell *tableViewCell;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indictor;

- (IBAction)back:(id)sender;
- (IBAction)refresh:(id)sender;
@end
