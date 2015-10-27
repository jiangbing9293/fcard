//
//  freelancerAppDelegate.m
//  FCARD
//
//  Created by FREELANCER on 14-6-25.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "freelancerAppDelegate.h"
#import "MyDevice.h"
#import "MyCard.h"

NSMutableArray *device_list;
NSMutableArray *card_list;
FMDatabase *database;
MyDevice *device;

@implementation freelancerAppDelegate


+ (NSString *) pathForDocumentsResource:(NSString *) relativePath
{
    static NSString* documentsPath = nil;
    
    if (nil == documentsPath) {
        
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [[dirs objectAtIndex:0] retain];
    }
    
    return [documentsPath stringByAppendingPathComponent:relativePath];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self openDatabase];
    [self createTable];
    device_list = [[NSMutableArray alloc] init];
    card_list = [[NSMutableArray alloc] init];
    device = [[MyDevice alloc]init];
    dispatch_queue_t load_data = dispatch_queue_create("load_data", NULL);
    dispatch_async(load_data, ^{
        [self loadDeviceFromDatabase];
        [self loadCardFromDatabase];
    });
    dispatch_release(load_data);
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self closeDatabase];
    device_list = nil;
}

#pragma mark - SQLite Methods

- (void)openDatabase
{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databaseFilePath = [[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    
    database = [[FMDatabase alloc] initWithPath:databaseFilePath];
    
    if ([database open])
        NSLog(@"open sqlite db ok.");
}

- (void)closeDatabase
{
    if (database != NULL) {
        [database close];
        [database release];
        NSLog(@"close sqlite db ok.");
    }
}

- (void)createTable
{
    if (database != NULL) {
        
        if (![database executeUpdate:SQLCMD_CREATE_TABLE_DEVICE]) NSLog(@"Can not create table device");
        /* Edit here while table columns been modified */
        if (![database columnExists:@"device" columnName:@"rtsp"])
        {
            [database executeUpdate:SQLCMD_ALTER_TABLE_DEVICE];
            printf("add column rtsp for device");
        }
        
        if (![database executeUpdate:SQLCMD_CREATE_TABLE_CARD]) NSLog(@"Can not create table card");
        
        if (![database executeUpdate:SQLCMD_CREATE_TABLE_DOOR_PWD]) NSLog(@"Can not create table door_pwd");
    }
}

- (void)loadDeviceFromDatabase {
    
    if (database != NULL) {
        
        FMResultSet *rs = [database executeQuery:@"SELECT * FROM device"];
        
        while([rs next]) {
            
            NSString *dev_address = [rs stringForColumn:@"dev_address"];
            NSString *dev_port = [rs stringForColumn:@"dev_port"];
            NSString *dev_password = [rs stringForColumn:@"dev_password"];
            NSString *dev_sn = [rs stringForColumn:@"dev_sn"];
            NSString *cam_address = [rs stringForColumn:@"cam_address"];
            NSString *cam_port = [rs stringForColumn:@"came_port"];
            NSString *channel = [rs stringForColumn:@"channel"];
            NSString *view_acc = [rs stringForColumn:@"view_acc"];
            NSString *view_pwd = [rs stringForColumn:@"view_pwd"];
            NSString *m1 = [rs stringForColumn:@"m1"];
            NSString *m2 = [rs stringForColumn:@"m2"];
            NSString *m3 = [rs stringForColumn:@"m3"];
            NSString *m4 = [rs stringForColumn:@"m4"];
            NSString *rtsp_ = [rs stringForColumn:@"rtsp"];
            NSLog(@"Load device(%@, %@, %@, %@, rtsp:%@)", dev_address, dev_sn, dev_port, dev_password, rtsp_);
            
            MyDevice *device = [[MyDevice alloc]initWithDevAdress:dev_address DevPort:dev_port DevPassword:dev_password DevSN:dev_sn CamAdress:cam_address CamPort:cam_port Channel:channel ViewAcc:view_acc ViewPwd:view_pwd M1:m1 M2:m2 M3:m3 M4:m4 rtsp:rtsp_];
            
            [device_list addObject:device];
            [device release];
        }
        
        [rs close];
    }
}

- (void)loadCardFromDatabase {
    
    if (database != NULL) {
        
        FMResultSet *rs = [database executeQuery:@"SELECT * FROM card"];
        
        while([rs next]) {
            
            NSString *card_num = [rs stringForColumn:@"card_num"];
            NSString *card_name = [rs stringForColumn:@"card_name"];
            NSString *card_tel = [rs stringForColumn:@"card_tel"];
            NSString *card_info = [rs stringForColumn:@"card_info"];
            
            NSLog(@"Load card(%@, %@,", card_num, card_name);
            
            MyCard *card = [[MyCard alloc] initWith:card_num cardName:card_name cardTel:card_tel cardInfo:card_info];
            
            [card_list addObject:card];
            [card release];
        }
        
        [rs close];
    }
}


@end
