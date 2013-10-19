//
//  AppSession.h
//  cafejakco
//
//  Created by 강별 on 13. 10. 19..
//  Copyright (c) 2013년 doubleline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSession : NSObject

#pragma mark -
#pragma mark Settter
+ (void)setUserId:(NSString *)_userId;
+ (void)setUsername:(NSString *)_username;
+ (void)setNickname:(NSString *)_nickname;
+ (void)setIsLogin:(NSString *)_isLogin;

#pragma mark -
#pragma mark Getter
+ (NSString *)getUserId;
+ (NSString *)getUsername;
+ (NSString *)getNickname;
+ (NSString *)getIsLogin;

#pragma mark -
#pragma mark Session info
+ (void)removeSession;
+ (BOOL)aliveSession;

@end
