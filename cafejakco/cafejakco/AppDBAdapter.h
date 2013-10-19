//
//  AppDBAdapter.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 30..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDBAdapter : NSObject

+ (void)initDB;

+ (void)AddContentsWithKey:(NSString *)key value:(NSString *)value;
+ (void)UpdateContentsWithKey:(NSString *)key value:(NSString *)value;
+ (void)RemoveHeritageWithKey:(NSString *)key;

+ (NSArray *)GetContentsArray;
+ (NSString *)GetContentWithKey:(NSString *)key;

+ (void)RemoveDB;


+ (void)AppDBToSession;
+ (void)AppSessionToDB;

@end
