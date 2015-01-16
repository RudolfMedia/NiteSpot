//
//  RMMapSearchViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMMapSearchViewController.h"
#import "Spot.h"

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
        MKPointAnnotation *eatAnnotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D eatLocation = CLLocationCoordinate2DMake([spot.lat.firstObject doubleValue], [spot.lon.firstObject doubleValue]);
        eatAnnotation.coordinate = eatLocation;
        eatAnnotation.title = spot.spotTitle;

        [self.spotMapView addAnnotation:eatAnnotation];
    }

    for (Spot *spot in self.drinkSpotsArray) {
        MKPointAnnotation *drinkAnnotation = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D drinkLocation = CLLocationCoordinate2DMake([spot.lat.firstObject doubleValue], [spot.lon.firstObject doubleValue]);
        drinkAnnotation.coordinate = drinkLocation;
        drinkAnnotation.title = spot.spotTitle;

        [self.spotMapView addAnnotation:drinkAnnotation];
    }

    for (Spot *spot in self.attendSpotsArray) {
        MKPointAnnotation *attendAnnotation = [[MKPointAnnotation alloc] init];
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

@end
