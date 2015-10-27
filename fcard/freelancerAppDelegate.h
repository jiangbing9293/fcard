//
//  freelancerAppDelegate.h
//  FCARD
//
//  Created by FREELANCER on 14-6-25.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "MyDevice.h"
#define SQLCMD_CREATE_TABLE_DEVICE @"CREATE TABLE IF NOT EXISTS device(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_address TEXT, dev_port TEXT, dev_password TEXT, dev_sn TEXT, cam_address TEXT, came_port TEXT, channel TEXT, view_acc TEXT, view_pwd TEXT, m1 TEXT, m2 TEXT, m3 TEXT, m4 TEXT)"

#define SQLCMD_CREATE_TABLE_CARD @"CREATE TABLE IF NOT EXISTS card(id INTEGER PRIMARY KEY AUTOINCREMENT, card_num TEXT, card_name TEXT, card_tel TEXT, card_info TEXT)"

#define SQLCMD_CREATE_TABLE_DOOR_PWD @"CREATE TABLE IF NOT EXISTS door_pwd(id INTEGER PRIMARY KEY AUTOINCREMENT, dev_sn TEXT,open_door_pwd TEXT, info TEXT, m1 TEXT,m2 TEXT,m3 TEXT,m4 TEXT)"

#define SQLCMD_ALTER_TABLE_DEVICE @"ALTER TABLE device ADD COLUMN rtsp TEXT"

extern NSMutableArray *device_list;
extern NSMutableArray *card_list;
extern FMDatabase *database;
extern MyDevice *device;

@interface freelancerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSString *) pathForDocumentsResource:(NSString *) relativePath;
- (void)openDatabase;
- (void)loadDeviceFromDatabase;
- (void)createTable;
- (void)closeDatabase;

@end
