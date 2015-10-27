//
//  MyDevice.h
//  FCARD
//
//  Created by Qu Shutang on 14-7-2.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDevice : NSObject

@property(nonatomic, assign) NSString *dev_address;
@property(nonatomic, assign) NSString *dev_port;
@property(nonatomic, assign) NSString *dev_password;
@property(nonatomic, assign) NSString *dev_sn;
@property(nonatomic, assign) NSString *cam_address;
@property(nonatomic, assign) NSString *cam_port;
@property(nonatomic, assign) NSString *channel;
@property(nonatomic, assign) NSString *view_acc;
@property(nonatomic, assign) NSString *view_pwd;
@property(nonatomic, assign) NSString *m1;
@property(nonatomic, assign) NSString *m2;
@property(nonatomic, assign) NSString *m3;
@property(nonatomic, assign) NSString *m4;
@property(nonatomic, assign) NSString *rtsp;

-(id) initWithDevAdress:(NSString *)dev_address DevPort:(NSString *)dev_port DevPassword:(NSString *)dev_password DevSN:(NSString *)dev_sn CamAdress:(NSString *)cam_address CamPort:(NSString *)cam_port Channel:(NSString *)channel ViewAcc:(NSString *)view_acc ViewPwd:(NSString *)view_pwd M1:(NSString *)m1 M2:(NSString *)m2 M3:(NSString *)m3 M4:(NSString *)m4 rtsp:(NSString*)rtsp_;
-(void) setDev:(MyDevice *)device;
@end
