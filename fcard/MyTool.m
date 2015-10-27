//
//  MyTool.m
//  FCARD
//
//  Created by FREELANCER on 14-6-29.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "MyTool.h"
#import "iToast.h"
#import "MyCard.h"

@implementation MyTool

/**密码掩码显示*/
+(NSString *)getHiddle:(NSString *)str
{
    NSString *hiddle = [[NSString alloc]initWithString:@""];
    for (int i = 0; i < [str length]; ++i) {
       hiddle = [hiddle stringByAppendingString:@"*"];
        if (i == ([str length] -1)) {
           hiddle = [hiddle stringByAppendingString:[str substringFromIndex:([str length] -1)]];
        }
    }
    return hiddle;
}
/** int 转二进制 NSString **/
+(NSString *)int2BinryStr:(int)value
{
    NSString *str = [[NSString alloc]initWithString:@""];
    switch (value) {
        case 0xf:
            str = @"1111";
            break;
        case 0xe:
            str = @"1110";
            break;
        case 0xd:
            str = @"1101";
            break;
        case 0xc:
            str = @"1100";
            break;
        case 0xb:
            str = @"1011";
            break;
        case 0xa:
            str = @"1010";
            break;
        case 0x9:
            str = @"1001";
            break;
        case 0x8:
            str = @"1000";
            break;
        case 0x7:
            str = @"0111";
            break;
        case 0x6:
            str = @"0110";
            break;
        case 0x5:
            str = @"0101";
            break;
        case 0x4:
            str = @"0100";
            break;
        case 0x3:
            str = @"0011";
            break;
        case 0x2:
            str = @"0010";
            break;
        case 0x1:
            str = @"0001";
            break;
        case 0x0:
            str = @"0000";
            break;

            
        default:
            break;
    }
    return str;
}
/**
 *@ BCD码转NSString
 **/
+(NSString*)bcd2str:(char[4])PASSWORD
{
    NSString *pwd = [[NSString alloc]initWithString:@""];
    for (int i = 0; i < 4; ++i)
    {
        NSString *s = [NSString stringWithFormat:@"%.2x",PASSWORD[i]];
        pwd = [pwd stringByAppendingString:s];
    }
    NSRange range;
    range = [pwd rangeOfString:@"f"];
    if (range.location > 8) {
        return @"";
    }
    return [pwd substringToIndex:range.location];
}
/**
 *@ 密码转BCD码
 **/
+(void)str2bcd:(char[4])PASSWORD str:(NSString*)pwd
{
    if ([pwd length] == 8) {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = [pwd substringToIndex:2];
        int t = [thrid intValue];
        PASSWORD[2] = (t/10)*16 + t%10;
        pwd = [pwd substringFromIndex:2];
        NSString *four = [pwd substringToIndex:2];
        int fo = [four intValue];
        PASSWORD[3] = (fo/10)*16 + fo%10;
    }
    else if([pwd length] == 7)
    {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = [pwd substringToIndex:2];
        int t = [thrid intValue];
        PASSWORD[2] = (t/10)*16 + t%10;
        pwd = [pwd substringFromIndex:2];
        NSString *four = [pwd substringToIndex:1];
        int fo = [four intValue];
        PASSWORD[3] = (fo%10)*16 + 0x0f;
    }
    else if([pwd length] == 6)
    {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = [pwd substringToIndex:2];
        int t = [thrid intValue];
        PASSWORD[2] = (t/10)*16 + t%10;
        PASSWORD[3] =0xFf;
    }
    else if([pwd length] == 5)
    {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        pwd = [pwd substringFromIndex:2];
        NSString *thrid = [pwd substringToIndex:1];
        int t = [thrid intValue];
        PASSWORD[2] = (t%10)*16 + 0x0f;
        PASSWORD[3] =0xFf;
    }
     else if([pwd length] == 4)
    {
        NSString *first = [pwd substringToIndex:2];
        int f = [first intValue];
        PASSWORD[0] = (f/10)*16 + f%10;
        pwd = [pwd substringFromIndex:2];
        NSString *second = [pwd substringToIndex:2];
        int s = [second intValue];
        PASSWORD[1] = (s/10)*16 + s%10;
        PASSWORD[2] = 0xff;
        PASSWORD[3] =0xFf;
    }
     else
     {
         PASSWORD[0] = 0xff;
         PASSWORD[1] = 0xff;
         PASSWORD[2] = 0xff;
         PASSWORD[3] = 0xff;
     }
}
/*
 * @ 根据卡号查询姓名
 **/
+(NSString *)getNameByID:(NSString*)cardid
{
    for (MyCard *card in card_list) {
        if ([cardid isEqualToString:[card card_num]])
        {
            return [card card_name];
        }
    }
    return cardid;
}
/*
 * @ 根据卡号查询密码
 **/
+(NSString *)getPwdByID:(NSString*)cardid
{
    for (MyCard *card in card_list) {
        if ([cardid isEqualToString:[card card_num]])
        {
            return [card card_tel];
        }
    }
    return cardid;
}
/**
    @ 验证SN的合法性
 */
+(BOOL)isSnRight:(NSString*)sn
{
    NSString *snRegex = @"^[A-Z]{2}-\\d{2}[1,2,4]\\d\\w\\d{8}$";
    NSPredicate *snPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",snRegex];
    BOOL right = [snPre evaluateWithObject:sn];
    if (right) {
        return YES;
    }
    return NO;
}

+(void) showAlert:(NSString *)title msg:(NSString*)msg
{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
    [[iToast makeText:msg] show];
}

+(void) showAlert:(NSString*)msg
{
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//    [alert show];
//    [alert release];
     [[iToast makeText:msg] show];
}
//获取当前日期
+(void)getVilidDate:(char*)date currentDate:(NSString *)cDate
{
    char c_date[5];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyMMddHHmm"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    if (cDate) {
        currentTime = cDate;
    }
#ifdef DEBUG
    NSLog(@"currentTime:%@",currentTime);
#endif
    NSString *first = [currentTime substringToIndex:2];
    int f = [first intValue];
    if (cDate) {
        c_date[0] = (f/10)*16 + f%10;
    }
    else{
        c_date[0] = (f/10)*16 + f%10+16;
    }
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *second = [currentTime substringToIndex:2];
    int s = [second intValue];
    c_date[1] = (s/10)*16 + s%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *thrid = [currentTime substringToIndex:2];
    int t = [thrid intValue];
    c_date[2] = (t/10)*16 + t%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *four = [currentTime substringToIndex:2];
    int fo = [four intValue];
    c_date[3] = (fo/10)*16 + fo%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *five = [currentTime substringToIndex:2];
    int fi = [five intValue];
    c_date[4] = (fi/10)*16 + fi%10;
    
    memcpy(date, c_date, sizeof(c_date));
    
#ifdef DEBUG
    printf("%s",date);
#endif
}

+(void) getCardNum:(char*)cardNum Num:(long long)num
{
    char ch[5];
    memcpy(ch, &num,5);
    cardNum[0] = ch[4];
    cardNum[1] = ch[3];
    cardNum[2] = ch[2];
    cardNum[3] = ch[1];
    cardNum[4] = ch[0];
}


+(NSString*)devDateToDate:(char[])date
{
    char d[7];
    for (int i = 0; i < 7; ++i) {
        d[i] = (date[i]/16)*10+date[i]%16;
    }
    return [[NSString alloc]initWithFormat:@"20%d年%d月%d日 %d时%d分",d[6],d[4],d[3],d[2],d[1]];
}

+(NSString*)recordDateToDate:(char[])date
{
    char d[6];
    for (int i = 0; i < 6; ++i) {
        d[i] = (date[i]/16)*10+date[i]%16;
    }
    return [[NSString alloc]initWithFormat:@"20%d年%02d月%02d日 %02d:%02d:%02d",d[0],d[1],d[2],d[3],d[4],d[5]];
}
+(void) getPhoneDateToDev:(char*)date
{
    char c_date[7];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ssmmHHddMMEEyy"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    NSString *first = [currentTime substringToIndex:2];
    int f = [first intValue];
    c_date[0] = (f/10)*16 + f%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *second = [currentTime substringToIndex:2];
    int s = [second intValue];
    c_date[1] = (s/10)*16 + s%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *thrid = [currentTime substringToIndex:2];
    int t = [thrid intValue];
    c_date[2] = (t/10)*16 + t%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *four = [currentTime substringToIndex:2];
    int fo = [four intValue];
    c_date[3] = (fo/10)*16 + fo%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *five = [currentTime substringToIndex:2];
    int fi = [five intValue];
    c_date[4] = (fi/10)*16 + fi%10;
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *six = [currentTime substringToIndex:2];
    if ([six isEqualToString:@"周日"]) {
        c_date[5] = 7;
    }else if([six isEqualToString:@"周一"])
    {
        c_date[5] = 1;
    }else if([six isEqualToString:@"周二"])
    {
        c_date[5] = 2;
    }else if([six isEqualToString:@"周三"])
    {
        c_date[5] = 3;
    }else if([six isEqualToString:@"周四"])
    {
        c_date[5] = 4;
    }else if([six isEqualToString:@"周五"])
    {
        c_date[5] = 5;
    }else if([six isEqualToString:@"周六"])
    {
        c_date[5] = 6;
    }
    
    currentTime = [currentTime substringFromIndex:2];
    NSString *seven = [currentTime substringToIndex:2];
    int se = [seven intValue];
    
    c_date[6] = (se/10)*16 + se%10;
    
    memcpy(date, c_date, sizeof(c_date));
}

+(int)charsToInt:(char[])data
{
    int value = 0;
    value |= (data[0] & 0xff) << 24;
    value |= (data[1] & 0xff) << 16;
    value |= (data[2] & 0xff) << 8;
    value |= data[3] & 0xff;
    return value;
}
+(int)charsToIntForCardNum:(char[])data
{
    int value = 0;
    value |= (data[0] & 0xff) << 24;
    value |= (data[1] & 0xff) << 24;
    value |= (data[2] & 0xff) << 16;
    value |= (data[3] & 0xff) << 8;
    value |= data[4] & 0xff;
    return value;
}
+(void)intToChars:(int)value chars:(char[])data
{
    data[0] = (char)(value >>24);
    data[1] = (char)(value >>16);
    data[2] = (char)(value >>8);
    data[3] = value;
}

@end
