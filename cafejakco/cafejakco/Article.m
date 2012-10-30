//
//  Article.m
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 23..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize title = _title;
@synthesize content = _content;
@synthesize created = _created;
@synthesize likes = _likes;
@synthesize username = _username;
@synthesize image = _image;

- (id)initWithTitle:(NSString *)title Content:(NSString *)content Created:(NSString *)created Likes:(int)likes Username:(NSString *)username
{
    self = [super init];
    
    if(self)
    {
        self.title = title;
        self.content = content;
        self.created = created;
        self.likes = likes;
        self.username = username;
    }
    return self;
}


@end
