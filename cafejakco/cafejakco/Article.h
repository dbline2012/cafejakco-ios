//
//  Article.h
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 23..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created;
@property (nonatomic, assign) int likes;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *image;

- (id)initWithTitle:(NSString *)title Content:(NSString *)content Created:(NSString *)created Likes:(int)likes Username:(NSString *)username;

@end
