//
//  JakcoPin.h
//  cafejakco
//
//  Created by 강별 on 13. 10. 14..
//  Copyright (c) 2013년 doubleline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface JakcoPin : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@end
