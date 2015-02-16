//
//  LocationCell.m
//  NiteSpot
//
//  Created by Dan Rudolf on 2/15/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "LocationCell.h"


@implementation LocationCell

- (void)awakeFromNib {

    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoicnVkb2xmbWVkaWEiLCJhIjoidDZSa2hYcyJ9.ucXq4hJcdZTuInE-gtM0ug"];
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"rudolfmedia.kpbaioeo"];

    self.mapView = [[RMMapView alloc] initWithFrame:self.viewForBaselineLayout.bounds andTilesource:tileSource];

    [self.mapView addSubview:self.viewForBaselineLayout];

}

@end
