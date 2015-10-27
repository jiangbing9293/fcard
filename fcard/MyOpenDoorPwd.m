//
//  MyOpenDoorPwd.m
//  FCARD
//
//  Created by jiang bing on 15/5/23.
//  Copyright (c) 2015年 FREELANCER. All rights reserved.
//

#import "MyOpenDoorPwd.h"

@implementation MyOpenDoorPwd

@synthesize dev_sn = _dev_sn;
@synthesize open_door_pwd = _open_door_pwd;
@synthesize info = _info;
@synthesize m1 = _m1;
@synthesize m2 = _m2;
@synthesize m3 = _m3;
@synthesize m4 = _m4;

-(id) initWithDevsn:(NSString *)dev_sn pwd:(NSString *)open_door_pwd info:(NSString *)info M1:(NSString *)m1 M2:(NSString *)m2 M3:(NSString *)m3 M4:(NSString *)m4
{
    self = [super init];
    if (self) {
        _dev_sn = [[NSString alloc]initWithFormat:@"%@",dev_sn];
        _open_door_pwd = [[NSString alloc]initWithFormat:@"%@",open_door_pwd];
        _info = [[NSString alloc]initWithFormat:@"%@",info];
        _m1 = [[NSString alloc]initWithFormat:@"%@",m1];
        _m2 = [[NSString alloc]initWithFormat:@"%@",m2];
        _m3 = [[NSString alloc]initWithFormat:@"%@",m3];
        _m4 = [[NSString alloc]initWithFormat:@"%@",m4];
    }
    return self;
}

-(void) setOdp:(MyOpenDoorPwd *)doorPwd
{
    if(self)
    {
        _dev_sn = [doorPwd dev_sn];
        _open_door_pwd = [doorPwd open_door_pwd];
        _info = [doorPwd info];
        _m1 = [doorPwd m1];
        _m2 = [doorPwd m2];
        _m3 = [doorPwd m3];
        _m4 = [doorPwd m4];
    }
}
-(void)dealloc
{
    [super dealloc];
    _dev_sn = nil;
    _info = nil;
    _open_door_pwd = nil;
    _m1 = nil;
    _m2 = nil;
    _m3 = nil;
    _m4 = nil;
}

@end
