//
//  MyTool.h
//  FCARD
//
//  Created by FREELANCER on 14-6-29.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

extern NSMutableArray *card_list;
#define DEBUG 1
#import <Foundation/Foundation.h>

@interface MyTool : NSObject
/**密码掩码显示*/
+(NSString *)getHiddle:(NSString *)str;
+(void) showAlert:(NSString *)title msg:(NSString*)msg;
+(void) showAlert:(NSString*)msg;
+(void) getVilidDate:(char*)date currentDate:(NSString *)cDate;
+(void) getCardNum:(char*)cardNum Num:(long long)num;

+(NSString*)devDateToDate:(char[])date;
+(NSString*)recordDateToDate:(char[])date;
+(void) getPhoneDateToDev:(char*)date;

+(int)charsToInt:(char[])data;
+(int)charsToIntForCardNum:(char[])data;
+(void)intToChars:(int)value chars:(char[])data;

+(BOOL)isSnRight:(NSString*)sn;
+(NSString *)getNameByID:(NSString*)cardid;
+(NSString *)getPwdByID:(NSString*)cardid;
/** 
 *@ 密码转BCD码
 **/
+(void)str2bcd:(char[4])PASSWORD str:(NSString*)pwd;
/**
 *@ BCD码转NSString
 **/
+(NSString*)bcd2str:(char[4])PASSWORD;
/** int 转二进制 NSString **/
+(NSString *)int2BinryStr:(int)value;
@end
