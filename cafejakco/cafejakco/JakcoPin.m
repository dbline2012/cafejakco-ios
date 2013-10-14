//
//  JakcoPin.m
//  cafejakco
//
//  Created by 강별 on 13. 10. 14..
//  Copyright (c) 2013년 doubleline. All rights reserved.
//

#import "JakcoPin.h"

@implementation JakcoPin

@synthesize coordinate,title,subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

@end
