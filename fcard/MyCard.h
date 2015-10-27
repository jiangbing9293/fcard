//
//  MyCard.h
//  FCARD
//
//  Created by Qu Shutang on 14-7-12.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCard : NSObject

@property (nonatomic, assign) NSString *card_num;
@property (nonatomic, assign) NSString *card_name;
@property (nonatomic, assign) NSString *card_tel;
@property (nonatomic, assign) NSString *card_info;

-(MyCard *) initWith:(NSString *)card_num_ cardName:(NSString *)card_name_ cardTel:(NSString *)card_tel_ cardInfo:(NSString *)card_info_;

@end
