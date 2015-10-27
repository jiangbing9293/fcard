//
//  MyOpenDoorPwd.h
//  FCARD
//
//  Created by jiang bing on 15/5/23.
//  Copyright (c) 2015年 FREELANCER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOpenDoorPwd : NSObject

@property(nonatomic, assign) NSString *dev_sn;
@property(nonatomic, assign) NSString *open_door_pwd;
@property(nonatomic, assign) NSString *info;
@property(nonatomic, assign) NSString *m1;
@property(nonatomic, assign) NSString *m2;
@property(nonatomic, assign) NSString *m3;
@property(nonatomic, assign) NSString *m4;
-(id) initWithDevsn:(NSString *)dev_sn pwd:(NSString *)open_door_pwd info:(NSString *)info M1:(NSString *)m1 M2:(NSString *)m2 M3:(NSString *)m3 M4:(NSString *)m4;
-(void) setOdp:(MyOpenDoorPwd *)doorPwd;
@end
