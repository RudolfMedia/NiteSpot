//
//  RMMapSearchViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMMapSearchViewController.h"
#import "Spot.h"
#import "Mapbox.h"


@interface RMMapSearchViewController ()<CLLocationManagerDelegate, RMMapViewDelegate>

@property CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) RMMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (strong, nonatomic) RMAnnotation *eatAnnotation;
@property (strong, nonatomic) RMAnnotation *drinkAnnotaion;
@property (strong, nonatomic) RMAnnotation *attendAnnotaion;

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
    self.mapView.tintColor = [UIColor blackColor];
    //self.mapView.clusteringEnabled = YES;
    [self.mapView showsUserLocation];

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
    CLLocationCoordinate2D downtown;
    downtown = CLLocationCoordinate2DMake(40.4405824, -80.0045282);

    [self.mapView setCenterCoordinate:downtown];
    self.mapView.zoom = 13;

}

- (void)setMapRegion{

    CLLocationCoordinate2D zoomCenter;
    zoomCenter = self.locationManager.location.coordinate;

    [self.mapView setCenterCoordinate:zoomCenter];
    [self.mapView showsUserLocation];

    
}



#pragma mark -MapViewDelegates

-(void)addAnnotations{


    for (Spot *spot in self.dataLoader.eatSpotsArray) {

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([spot.lat floatValue], [spot.lon floatValue]);

        self.eatAnnotation = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:location andTitle:spot.spotTitle];
        self.eatAnnotation.annotationType = @"a";
        self.eatAnnotation.clusteringEnabled = YES;
        [self.mapView addAnnotation:self.eatAnnotation];
    }

    for (Spot *spot in self.dataLoader.drinkSpotsArray) {

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([spot.lat floatValue], [spot.lon floatValue]);

        self.drinkAnnotaion = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:location andTitle:spot.spotTitle];
        self.drinkAnnotaion.annotationType = @"b";
        self.drinkAnnotaion.clusteringEnabled = YES;
        [self.mapView addAnnotation:self.drinkAnnotaion];

    }

    for (Spot *spot in self.dataLoader.attendSpotsArray) {

        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([spot.lat floatValue], [spot.lon floatValue]);

        self.attendAnnotaion = [[RMAnnotation alloc] initWithMapView:self.mapView coordinate:location andTitle:spot.spotTitle];
        self.attendAnnotaion.annotationType = @"d";
        self.attendAnnotaion.clusteringEnabled = YES;
        [self.mapView addAnnotation:self.attendAnnotaion];

    }

}



-(RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation{

    RMMapLayer *layer = nil;

     if([annotation.annotationType isEqualToString:@"a"]){

         RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:nil
                                                           tintColorHex:@"7ED934"];
         marker.canShowCallout = YES;
         marker.borderColor = (__bridge CGColorRef)([UIColor blackColor]);

        layer = marker;
        return layer;
    }

    else if ([annotation.annotationType isEqualToString:@"b"]){

        RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:nil
                                                          tintColorHex:@"DD4F4D"];
        marker.canShowCallout = YES;
        marker.borderColor = (__bridge CGColorRef)([UIColor blackColor]);

        layer = marker;
        return layer;

    }

    else if ([annotation.annotationType isEqualToString:@"d"]){

        RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:nil
                                                          tintColorHex:@"3BBDE2"];
        marker.canShowCallout = YES;
        marker.borderColor = (__bridge CGColorRef)([UIColor blackColor]);


        layer = marker;
        return layer;

    }

    return layer;

}


@end
