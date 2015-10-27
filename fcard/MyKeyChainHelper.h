//
//  MyKeyChainHelper.h
//  FCARD
//
//  Created by FREELANCER on 14-6-28.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#define KEY_PASSWORD  @"yzdz.fcard.password"
#define KEY_QUESTION @"yzdz.fcard.question"
#define KEY_ANSWER @"yzdz.fcard.answer"
#define KEY_RATE @"yzdz.fcard.rate"

#import <Foundation/Foundation.h>

@interface MyKeyChainHelper : NSObject

//验证密码操作
+ (void)savePsaaword:(NSString*)pwd psaawordService:(NSString*)pwdService;
+ (void)deleteWithPsaawordService:(NSString*)pwdService;
+ (NSString*) getPasswordWithService:(NSString*)pwdService;
//密码问题操作
+ (void)saveQuestion:(NSString*)question questionService:(NSString*)quesService;
+ (void)deleteWithQuestionService:(NSString *)quesService;
+ (NSString*)getQuestionWithService:(NSString*)quesService;
//密码答案操作
+ (void)saveAnswser:(NSString *)answer answerService:(NSString *)answerService;
+ (void)deleteWithAnswerService:(NSString *)answService;
+ (NSString*)getAnswerWithService:(NSString*)answService;
//刷新频率
+ (void)saveRate:(NSString *)rate answerService:(NSString *)rateService;
+ (void)deleteWithRateService:(NSString *)rateService;
+ (NSString*)getRateWithService:(NSString*)rateService;
@end
