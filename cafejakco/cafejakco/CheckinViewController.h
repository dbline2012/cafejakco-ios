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
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)actionCheckin:(id)sender;

@end
