//
//  DeviceTableViewCell.m
//  FCARD
//
//  Created by FREELANCER on 14-7-1.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

@synthesize lb_sn = _lb_sn;
@synthesize lb_m1 = _lb_m1;
@synthesize lb_m2 = _lb_m2;
@synthesize lb_m3 = _lb_m3;
@synthesize lb_m4 = _lb_m4;

@synthesize sn = _sn;
@synthesize m1 = _m1;
@synthesize m2 = _m2;
@synthesize m3 = _m3;
@synthesize m4 = _m4;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _m1 = [[NSString alloc]init];
        _m2 = [[NSString alloc]init];
        _m3 = [[NSString alloc]init];
        _m4 = [[NSString alloc]init];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [_m1 release];
    [_lbM2 release];
    [_lbM3 release];
    [_lbM4 release];
    [super dealloc];
    [_lb_sn release];
    [_lb_m1 release];
    [_lb_m2 release];
    [_lb_m3 release];
    [_lb_m4 release];
}
- (void)hidden1
{
    [_lbM2 setHidden:YES];
    [_lbM3 setHidden:YES];
    [_lbM4 setHidden:YES];
    
    [_lb_m2 setHidden:YES];
    [_lb_m3 setHidden:YES];
    [_lb_m4 setHidden:YES];
}
- (void)hidden2
{
    [_lbM3 setHidden:YES];
    [_lbM4 setHidden:YES];
    
    [_lb_m3 setHidden:YES];
    [_lb_m4 setHidden:YES];
}

-(void)setSn:(NSString *)sn
{
    if (![sn isEqualToString:_sn]) {
        _sn = [sn copy];
    }
    _lb_sn.text =_sn;
}

-(void)setM1:(NSString *)m1
{
    if (![m1 isEqualToString:_m1]) {
        _m1 = [m1 copy];
    }
    _lb_m1.text = _m1;
}

-(void)setM2:(NSString *)m2
{
    if (![m2 isEqualToString:_m2]) {
        _m2 = [m2 copy];
    }
    _lb_m2.text = _m2;
}

-(void)setM3:(NSString *)m3
{
    if (![m3 isEqualToString:_m3]) {
        _m3 = [m3 copy];
    }
    _lb_m3.text = _m3;
}

-(void)setM4:(NSString *)m4
{
    if (![m4 isEqualToString:_m4]) {
        _m4 = [m4 copy];
    }
    _lb_m4.text = _m4;
}

@end
