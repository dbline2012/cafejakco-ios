//
//  Task.m
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 22..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize name = _name;
@synthesize done = _done;

- (id)initWithName:(NSString *)name done:(BOOL)done {
    self = [super init];
    
    if(self) {
        self.name = name;
        self.done = done;
    }
    return self;
}

@end
