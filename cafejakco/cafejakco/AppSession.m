//
//  AppSession.m
//  cafejakco
//
//  Created by 강별 on 13. 10. 19..
//  Copyright (c) 2013년 doubleline. All rights reserved.
//

#import "AppSession.h"

@implementation AppSession

#pragma mark -
#pragma mark Define key
#define USERID      @"USERID"
#define USERNAME    @"USERNAME"
#define NICKNAME    @"NICKNAME"
#define ISLOGIN     @"ISLOGIN"

#pragma mark -
#pragma mark Set app info
+ (void)setUserId:(NSString *)_userId
{
    [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:USERID];
}
+ (void)setUsername:(NSString *)_username
{
    [[NSUserDefaults standardUserDefaults] setObject:_username forKey:USERNAME];
}
+ (void)setNickname:(NSString *)_nickname
{
    [[NSUserDefaults standardUserDefaults] setObject:_nickname forKey:NICKNAME];
}
+ (void)setIsLogin:(NSString *)_isLogin
{
    [[NSUserDefaults standardUserDefaults] setObject:_isLogin forKey:ISLOGIN];
}

#pragma mark -
#pragma mark Get app info
+ (NSString *)getUserId
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERID];
}
+ (NSString *)getUsername
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME];
}
+ (NSString *)getNickname
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:NICKNAME];
}
+ (NSString *)getIsLogin
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:ISLOGIN];
}

#pragma mark -
#pragma mark Session info
+ (void)removeSession
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NICKNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ISLOGIN];
}
+ (BOOL)aliveSession
{
    if ([self getUsername] || [self getNickname] || [self getIsLogin])
        return YES;
    else
        return NO;
}


@end
