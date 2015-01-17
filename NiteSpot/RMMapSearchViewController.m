//
//  RMMapSearchViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMMapSearchViewController.h"
#import "Spot.h"
#import "RMEatAnnotation.h"
#import "RMDrinkAnnotation.h"
#import "RMAttendAnnotation.h"

@interface RMMapSearchViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *spotMapView;

@end

@implementation RMMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.spotMapView.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

    for (Spot *spot in self.eatSpotsArray) {
        RMEatAnnotation *eatAnnotation = [[RMEatAnnotation alloc] init];
        CLLocationCoordinate2D eatLocation = CLLocationCoordinate2DMake([spot.lat.firstObject doubleValue], [spot.lon.firstObject doubleValue]);
        eatAnnotation.coordinate = eatLocation;
        eatAnnotation.title = spot.spotTitle;

        [self.spotMapView addAnnotation:eatAnnotation];
    }

    for (Spot *spot in self.drinkSpotsArray) {
        RMDrinkAnnotation *drinkAnnotation = [[RMDrinkAnnotation alloc] init];
        CLLocationCoordinate2D drinkLocation = CLLocationCoordinate2DMake([spot.lat.firstObject doubleValue], [spot.lon.firstObject doubleValue]);
        drinkAnnotation.coordinate = drinkLocation;
        drinkAnnotation.title = spot.spotTitle;

        [self.spotMapView addAnnotation:drinkAnnotation];
    }

    for (Spot *spot in self.attendSpotsArray) {
        RMAttendAnnotation *attendAnnotation = [[RMAttendAnnotation alloc] init];
        CLLocationCoordinate2D attendLocation = CLLocationCoordinate2DMake([spot.lat.firstObject doubleValue], [spot.lon.firstObject doubleValue]);
        attendAnnotation.coordinate = attendLocation;
        attendAnnotation.title = spot.spotTitle;

        [self.spotMapView addAnnotation:attendAnnotation];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    self.spotMapView.alpha = 0;

    [UIView transitionWithView:self.spotMapView
                      duration:0.40f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        self.spotMapView.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];
    
    
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKAnnotationView *spotView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationPin"];

    UIImageView *eatPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eatPin"]];
    UIImageView *drinkPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drinkPin"]];
    UIImageView *attendPin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attendPin"]];

    if([annotation isKindOfClass: [MKUserLocation class]]) {
        return nil;
    }

    else if ([annotation isKindOfClass:[RMEatAnnotation class]]){

        [spotView addSubview:eatPin];
    }

    else if ([annotation isKindOfClass:[RMDrinkAnnotation class]]){

        [spotView addSubview:drinkPin];
    }

    else if ([annotation isKindOfClass:[RMAttendAnnotation class]]){

        [spotView addSubview:attendPin];
    }

    spotView.canShowCallout = YES;
    [spotView setCenterOffset:CGPointMake(0, -35)];
    return spotView;
}

@end
