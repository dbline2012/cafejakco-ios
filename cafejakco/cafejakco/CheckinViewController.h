//
//  CheckinViewController.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 28..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface CheckinViewController : UIViewController <MKMapViewDelegate>
{
    MKUserLocation *myLocation;
    BOOL viewMyLocation;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)actionCheckin:(id)sender;
- (IBAction)actionMyLocation:(id)sender;
- (BOOL)isEnableCheckin;
- (double)distanceWithCoordinate:(CLLocationCoordinate2D)curCoord oldCoord:(CLLocationCoordinate2D)oldCoord;
@end
