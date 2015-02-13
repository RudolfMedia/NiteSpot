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
#import "Mapbox.h"

@interface RMMapSearchViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property CLLocationCoordinate2D currentLocation;
@property RMMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *spotMapView;

@end

@implementation RMMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.spotMapView setHidden:YES];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoicnVkb2xmbWVkaWEiLCJhIjoidDZSa2hYcyJ9.ucXq4hJcdZTuInE-gtM0ug"];
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"rudolfmedia.kpbaioeo"];

    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];

    [self.view addSubview:self.mapView];

    self.mapView.zoom = 15;
    [self addAnnotations];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addAnnotation:)
                                                 name:@"GeocodeDone"
                                               object:nil];

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

    [self.mapView setCenterCoordinate:zoomCenter];
    [self.mapView showsUserLocation];

    
}

-(void)addAnnotations{
    NSLog(@"Add Annotations");

    for (Spot *spot in self.dataLoader.allSpotsArray) {

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(spot.lat.floatValue, spot.lon.floatValue);

        RMPointAnnotation *annotation = [[RMPointAnnotation alloc] initWithMapView:self.mapView coordinate:location andTitle:spot.spotTitle];

        [self.mapView addAnnotation:annotation];

    }

}



@end
