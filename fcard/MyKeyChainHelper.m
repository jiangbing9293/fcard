//
// MyKeyChainHelper.m
//  FCARD
//
//  Created by FREELANCER on 14-6-28.
//  Copyright (c) 2014年 FREELANCER. All rights reserved.
//

#import "MyKeyChainHelper.h"

@implementation MyKeyChainHelper

+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void) savePsaaword:(NSString*)pwd psaawordService:(NSString*)pwdService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:pwdService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:pwd] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (void) deleteWithPsaawordService:(NSString*)pwdService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:pwdService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

+ (NSString*) getPasswordWithService:(NSString*)pwdService
{
    NSString* ret = [[NSString alloc] init];
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:pwdService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", pwdService, e);
        }
        @finally
        {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+(void)saveQuestion:(NSString*)question questionService:(NSString*)quesService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:quesService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:question] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+(void)deleteWithQuestionService:(NSString *)quesService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:quesService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+(NSString*)getQuestionWithService:(NSString*)quesService
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:quesService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", quesService, e);
        }
        @finally
        {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;

}

+(void)saveAnswser:(NSString *)answer answerService:(NSString *)answerService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:answerService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:answer] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+(void)deleteWithAnswerService:(NSString *)answService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:answService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+(NSString*)getAnswerWithService:(NSString*)answService
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:answService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", answService, e);
        }
        @finally
        {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
+ (void)saveRate:(NSString *)rate answerService:(NSString *)rateService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:rateService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:rate] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
+ (void)deleteWithRateService:(NSString *)rateService
{
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:rateService];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+ (NSString*)getRateWithService:(NSString*)rateService
{
    NSString* ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeyChainQuery:rateService];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr)
    {
        @try
        {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)keyData];
        }
        @catch (NSException *e)
        {
            NSLog(@"Unarchive of %@ failed: %@", rateService, e);
        }
        @finally
        {
            
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}
@end
