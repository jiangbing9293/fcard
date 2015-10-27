//
//  MyCard.m
//  FCARD
//
//  Created by FREELANCER on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "MyCard.h"

@implementation MyCard

@synthesize card_num = _card_num;
@synthesize card_name = _card_name;
@synthesize card_tel = _card_tel;
@synthesize card_info = _card_info;

-(MyCard *) initWith:(NSString *)card_num_ cardName:(NSString *)card_name_ cardTel:(NSString *)card_tel_ cardInfo:(NSString *)card_info_
{
    [super init];
    if (self) {
        _card_num = [[NSString alloc]initWithFormat:@"%@",card_num_];
        _card_name = [[NSString alloc]initWithFormat:@"%@",card_name_];
        _card_tel = [[NSString alloc]initWithFormat:@"%@",card_tel_];
        _card_info = [[NSString alloc]initWithFormat:@"%@",card_info_];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    _card_num = nil;
    _card_name = nil;
    _card_tel = nil;
    _card_info = nil;
}

@end
