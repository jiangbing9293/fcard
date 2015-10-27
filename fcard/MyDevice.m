//
//  MyDevice.m
//  FCARD
//
//  Created by Qu Shutang on 14-7-2.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "MyDevice.h"

@implementation MyDevice

@synthesize dev_address = _dev_address;
@synthesize dev_port = _dev_port;
@synthesize dev_password = _dev_password;
@synthesize dev_sn = _dev_sn;
@synthesize cam_address = _cam_address;
@synthesize cam_port = _cam_port;
@synthesize channel = _channel;
@synthesize view_acc = _view_acc;
@synthesize view_pwd = _view_pwd;
@synthesize m1 = _m1;
@synthesize m2 = _m2;
@synthesize m3 = _m3;
@synthesize m4 = _m4;

-(id) initWithDevAdress:(NSString *)dev_address DevPort:(NSString *)dev_port DevPassword:(NSString *)dev_password DevSN:(NSString *)dev_sn CamAdress:(NSString *)cam_address CamPort:(NSString *)cam_port Channel:(NSString *)channel ViewAcc:(NSString *)view_acc ViewPwd:(NSString *)view_pwd M1:(NSString *)m1 M2:(NSString *)m2 M3:(NSString *)m3 M4:(NSString *)m4 rtsp:(NSString*)rtsp_
{
    self = [super init];
    if (self) {
        _dev_address = [[NSString alloc]initWithFormat:@"%@",dev_address];
        _dev_port = [[NSString alloc]initWithFormat:@"%@",dev_port];
        _dev_password = [[NSString alloc]initWithFormat:@"%@",dev_password];
        _dev_sn = [[NSString alloc]initWithFormat:@"%@",dev_sn];
        _cam_address = [[NSString alloc]initWithFormat:@"%@",cam_address];
        _cam_port = [[NSString alloc]initWithFormat:@"%@",cam_port];
        _channel = [[NSString alloc]initWithFormat:@"%@",channel];
        _view_acc = [[NSString alloc]initWithFormat:@"%@",view_acc];
        _view_pwd = [[NSString alloc]initWithFormat:@"%@",view_pwd];
        _m1 = [[NSString alloc]initWithFormat:@"%@",m1];
        _m2 = [[NSString alloc]initWithFormat:@"%@",m2];
        _m3 = [[NSString alloc]initWithFormat:@"%@",m3];
        _m4 = [[NSString alloc]initWithFormat:@"%@",m4];
        _rtsp = [[NSString alloc]initWithFormat:@"%@",rtsp_];;
    }
       return self;
}

-(void) setDev:(MyDevice *)device
{
    if(self)
    {
        _dev_address = [device dev_address];
        _dev_port = [device dev_port];
        _dev_password = [device dev_password];
        _dev_sn = [device dev_sn];
        _cam_address = [device cam_address];
        _cam_port = [device cam_port];
        _channel = [device channel];
        _view_acc = [device view_acc];
        _view_pwd = [device view_pwd];
        _m1 = [device m1];
        _m2 = [device m2];
        _m3 = [device m3];
        _m4 = [device m4];
        _rtsp = [device rtsp];
    }
}
-(void)dealloc
{
    [super dealloc];
    _dev_address = nil;
    _dev_port = nil;
    _dev_password = nil;
    _dev_sn = nil;
    _cam_address = nil;
    _cam_port = nil;
    _channel = nil;
    _view_acc = nil;
    _view_pwd = nil;
    _m1 = nil;
    _m2 = nil;
    _m3 = nil;
    _m4 = nil;
    _rtsp = nil;
}

@end
