//
//  Task.h
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 22..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) BOOL done;

- (id)initWithName:(NSString *)name done:(BOOL)done;

@end
