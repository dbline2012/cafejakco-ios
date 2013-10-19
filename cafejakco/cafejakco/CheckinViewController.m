//
//  CheckinViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 28..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "CheckinViewController.h"
#import "AppSession.h"

@interface CheckinViewController ()

@end



@implementation CheckinViewController

@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_checkin.png"] forBarMetrics:UIBarMetricsDefault];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = MAP_LATITUDE;
    zoomLocation.longitude = MAP_LONGITUDE;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.1 * METERS_PER_MILE, 0.1 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:zoomLocation];
    [annotation setTitle:@"작은커피집"];
    [annotation setSubtitle:@"서울특별시 노원구 월계1동 석계로13길"];

    [self.mapView addAnnotation:annotation];

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    myLocation = userLocation;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionCheckin:(id)sender {
    NSLog(@"%f %f", myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    if ([[AppSession getIsLogin] isEqualToString:@"NO"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커] 발자국" message:@"로그인 하셔야 발자국을 찍을 수 있습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        
        return;
        
    }
}
@end
