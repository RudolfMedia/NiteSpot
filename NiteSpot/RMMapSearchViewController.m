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

@interface RMMapSearchViewController ()<CLLocationManagerDelegate, RMMapViewDelegate>

@property CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) RMMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property RMAnnotation *eatAnnotation;
@property RMAnnotation *drinkAnnotaion;
@property RMAnnotation *attendAnnotaion;

@end

@implementation RMMapSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];

    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoicnVkb2xmbWVkaWEiLCJhIjoidDZSa2hYcyJ9.ucXq4hJcdZTuInE-gtM0ug"];
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"rudolfmedia.kpbaioeo"];

    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
    [self.mapView setDelegate:self];

    [self.view addSubview:self.mapView];

    self.mapView.zoom = 15;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addAnnotations)
                                                 name:@"GeocodeDone"
                                               object:nil];
    if (self.dataLoader.geoDone == 1) {
        [self addAnnotations];
    }

}

//-(void)viewWillAppear:(BOOL)animated{
//    self.spotMapView.alpha = 0;
//
//    [UIView transitionWithView:self.spotMapView
//                      duration:0.40f
//                       options:UIViewAnimationOptionCurveEaseIn
//                    animations:^{
//
//                        //any animatable attribute here.
//                        self.spotMapView.alpha = 1.0f;
//
//                    } completion:^(BOOL finished) {
//                    }];
//    
//    
//}

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

#pragma mark -MapViewDelegates

-(void)addAnnotations{

    NSLog(@"Add Annotations");
    NSLog(@"%i",self.dataLoader.geoDone);

    for (Spot *spot in self.dataLoader.eatSpotsArray) {

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([spot.lat floatValue], [spot.lon floatValue]);

        self.eatAnnotation = [[RMPointAnnotation alloc] initWithMapView:self.mapView coordinate:location andTitle:spot.spotTitle];

        [self.mapView addAnnotation:self.eatAnnotation];

    }

    for (Spot *spot in self.dataLoader.drinkSpotsArray) {

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([spot.lat floatValue], [spot.lon floatValue]);

        self.drinkAnnotaion = [[RMPointAnnotation alloc] initWithMapView:self.mapView coordinate:location andTitle:spot.spotTitle];

        [self.mapView addAnnotation:self.drinkAnnotaion];
    }

    for (Spot *spot in self.dataLoader.attendSpotsArray) {

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([spot.lat floatValue], [spot.lon floatValue]);

        self.attendAnnotaion = [[RMPointAnnotation alloc] initWithMapView:self.mapView coordinate:location andTitle:spot.spotTitle];

        [self.mapView addAnnotation:self.attendAnnotaion];
    }

}


-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{

    RMMarker *marker = [[RMMarker alloc] init];
    //marker.canShowCallout = YES;

    if ([annotation isUserLocationAnnotation]) {

        return nil;

    }

    else if (self.eatAnnotation){

        RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:nil tintColor:[UIColor greenColor]];
        marker.canShowCallout = YES;

        return marker;
    }

    else if (self.drinkAnnotaion){

        RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:nil tintColor:[UIColor redColor]];
        marker.canShowCallout = YES;

        return marker;
    }

    else if (self.attendAnnotaion){

        RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:nil tintColor:[UIColor blueColor]];
        marker.canShowCallout = YES;

        return marker;
    }

    return marker;

}


@end
