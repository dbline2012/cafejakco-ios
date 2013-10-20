//
//  CheckinViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 28..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "CheckinViewController.h"
#import "AppSession.h"
#import "HttpAdapter.h"

@interface CheckinViewController ()

@end



@implementation CheckinViewController

@synthesize mapView = _mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        viewMyLocation = FALSE;
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
    NSLog(@"[CheckinViewController/didUpdateUserLocation] longitude : %f, latitude : %f", myLocation.coordinate.longitude, myLocation.coordinate.latitude);
    
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
    if(![self isEnableCheckin])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커] 발자국" message:@"10m 이내에서만 체크인 할 수 있습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    NSDictionary *postDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [AppSession getUserId], @"user_id",
                                 nil];
    
    NSArray *responseArray = [httpAdapter SyncSendPostDataWithUrl:URL_JAKCO_SERVER_CHECKIN postData:postDataDic];
    
    if (responseArray && ([responseArray count] > 0)) {
        NSDictionary *resultDict = [responseArray objectAtIndex:0];
        
        if ([[resultDict objectForKey:@"status"] isEqualToString:@"fail"]) {
            NSLog(@"[CheckinViewController/actionCheckin] checkin fail");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커] 발자국" message:@"체크인 실패. 네트웍 상태를 확인하세요." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            [alert show];
            return;
        }
        else if([[resultDict objectForKey:@"status"] isEqualToString:@"success"])
        {
            NSLog(@"[CheckinViewController/actionCheckin] checkin success");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커] 발자국" message:@"체크인 완료" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            [alert show];
        }
    }
}

- (IBAction)actionMyLocation:(id)sender {
    CLLocationCoordinate2D zoomLocation;
    if (viewMyLocation) {
        zoomLocation.latitude = MAP_LATITUDE;
        zoomLocation.longitude = MAP_LONGITUDE;
        viewMyLocation = FALSE;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커] 발자국" message:@"한번더 누르시면 작은커피집 위치로 이동합니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        zoomLocation.latitude = myLocation.coordinate.latitude;
        zoomLocation.longitude = myLocation.coordinate.longitude;
        viewMyLocation = TRUE;
    }
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.1 * METERS_PER_MILE, 0.1 * METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (BOOL)isEnableCheckin
{
    CLLocationCoordinate2D jakcoLocation;
    jakcoLocation.latitude = MAP_LATITUDE;
    jakcoLocation.longitude = MAP_LONGITUDE;
    double distance = [self distanceWithCoordinate:myLocation.coordinate oldCoord:jakcoLocation];
    NSLog(@"[CheckinViewController/isEnableCheckin] distance : %f", distance * 1000.0);
    
    if (distance * 1000.0 <= 10.0) {
        return TRUE;
    }
    return FALSE;
}

- (double)distanceWithCoordinate:(CLLocationCoordinate2D)curCoord oldCoord:(CLLocationCoordinate2D)oldCoord
{
    double lat1 = curCoord.latitude;
    double lon1 = curCoord.longitude;
    double lat2 = oldCoord.latitude;
    double lon2 = oldCoord.longitude;
    
    double lat1rad = lat1 * 0.01745327;
    double lat2rad = lat2 * 0.01745327;
    double lon1rad = lon1 * 0.01745327;
    double lon2rad = lon2 * 0.01745327;
    
    double distance = acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(lon1rad - lon2rad)) * 6378.1;
    
    // * 1000 해야 meter 단위
    return  distance;
}

@end
