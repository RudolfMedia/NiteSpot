//
//  RMMapSearchViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMMapSearchViewController.h"

@interface RMMapSearchViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *spotMapView;

@end

@implementation RMMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

}

#pragma mark - Location Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{


    for (CLLocation *current in locations) {
        if (current.horizontalAccuracy < 100 && current.verticalAccuracy < 100) {
            [self.locationManager stopUpdatingLocation];
            [self setMapRegion];
            break;
        }
    }

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{

    NSLog(@"%@",error);
}

- (void)setMapRegion{

    CLLocationCoordinate2D zoomCenter;
    zoomCenter = self.locationManager.location.coordinate;

    MKCoordinateRegion zoomRegion = MKCoordinateRegionMakeWithDistance(zoomCenter, 800, 1000);

    [self.spotMapView setRegion:zoomRegion animated:YES];
    [self.spotMapView showsUserLocation];
    
    
}

@end
