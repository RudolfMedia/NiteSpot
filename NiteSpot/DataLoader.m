//
//  DataLoader.m
//  NiteSpot
//
//  Created by Dan Rudolf on 2/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "DataLoader.h"
#import "Spot.h"


@implementation DataLoader



- (void)downloadSpots{
    
    self.eatSpotsArray = [NSMutableArray new];
    self.drinkSpotsArray = [NSMutableArray new];
    self.attendSpotsArray = [NSMutableArray new];
    self.allSpotsArray = [NSMutableArray new];


    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://thenitespot.com/active_index.php"]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        self.spotJSONDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

        [self parseSpotObjects];

    }];
    
}


- (void)parseSpotObjects{

        for (NSDictionary *dictionary  in self.spotJSONDictionary) {

            Spot *spot = [[Spot alloc] initWithName:[dictionary objectForKey:@"title"]
                                               type:[dictionary objectForKey:@"type"]
                                               idNo:[dictionary objectForKey:@"id"]
                                             region:[dictionary objectForKey:@"region"]
                                               city:[dictionary objectForKey:@"city"]
                                             street:[dictionary objectForKey:@"street"]
                                              state:[dictionary objectForKey:@"state"]
                                                zip:[dictionary objectForKey:@"zip"]
                                              about:[dictionary objectForKey:@"about"]
                                                tel:[dictionary objectForKey:@"tel"]
                                           foodType:[dictionary objectForKey:@"eat"]
                                          drinkType:[dictionary objectForKey:@"drink"]
                                              price:[dictionary objectForKey:@"price"]
                                       dailySpecial:[dictionary objectForKey:@"general"]
                                            foodMon:[dictionary objectForKey:@"eat_Mon"]
                                            foodTue:[dictionary objectForKey:@"eat_Tue"]
                                            foodWed:[dictionary objectForKey:@"eat_Wed"]
                                            foodThu:[dictionary objectForKey:@"eat_Thu"]
                                            foodFri:[dictionary objectForKey:@"eat_Fri"]
                                            foodSat:[dictionary objectForKey:@"eat_sat"]
                                            foodSun:[dictionary objectForKey:@"eat_Sun"]
                                           drinkMon:[dictionary objectForKey:@"drink_Mon"]
                                           drinkTue:[dictionary objectForKey:@"drink_Tue"]
                                           drinkWed:[dictionary objectForKey:@"drink_Wed"]
                                           drinkThu:[dictionary objectForKey:@"drink_Thu"]
                                           drinkFri:[dictionary objectForKey:@"drink_Fri"]
                                           drinkSat:[dictionary objectForKey:@"drink_Sat"]
                                           drinkSun:[dictionary objectForKey:@"drink_Sun"]
                                               slug:[dictionary objectForKey:@"slug"]
                                              thumb:[dictionary objectForKey:@"thumb"]];

            [self.allSpotsArray addObject:spot];
        }

    [self formatSpots];
}


- (void)formatSpots{

    for (Spot *spot in self.allSpotsArray) {

        NSString *slug = spot.slug;
        slug = [slug stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

        if ([spot.price.class isSubclassOfClass:[NSNull class]]) {

            spot.price = @"$$";

        }

        NSString *parsedTitle = spot.spotTitle;
        parsedTitle = [parsedTitle stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
        spot.spotTitle = parsedTitle;

        NSString *urlString = [NSString stringWithFormat:@"http://www.thenitespot.com/images/spots/%@/%@",slug,spot.thumb];
        [spot addThumbURL:[NSURL URLWithString:urlString]];


        if ([spot.spotAbout isKindOfClass:[NSString class]]) {

        NSString *editedAbout = spot.spotAbout;
        editedAbout = [editedAbout stringByReplacingOccurrencesOfString:@"<br />"
                                                             withString:@""];
            spot.spotAbout = editedAbout;
        }
    }

    [self shuffleSpots];

}


- (void)shuffleSpots{

    NSUInteger countSpots = [self.allSpotsArray count];

    for (NSUInteger i = 0; i < countSpots; ++i) {

        NSUInteger nElements = countSpots - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [self.allSpotsArray exchangeObjectAtIndex:i withObjectAtIndex:n];

    }

    [self sortSpots];
    
}


- (void)sortSpots{

    for (Spot *spot in self.allSpotsArray) {

        if ([spot.type isEqualToString:@"a"]) {
    
            [self.eatSpotsArray addObject:spot];

        }
    
        else if ([spot.type isEqualToString:@"b"]){

            [self.drinkSpotsArray addObject:spot];

        }
    
        else if([spot.type isEqualToString:@"c"]){
    
            [self.eatSpotsArray addObject:spot];
            [self.drinkSpotsArray addObject:spot];

        }
    
        else if ([spot.type isEqualToString:@"d"]){

            [self.attendSpotsArray addObject:spot];

        }

    }
    [self geocodeAllSpots];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadDone" object:self];

}

- (void)geocodeAllSpots{

    NSString *apiKey = @"Fmjtd%7Cluu829u8n5%2Cb2%3Do5-9w1wdy";

    for (Spot *spot in self.allSpotsArray) {

        NSString *streetNoSpace = [spot.spotStreet stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

        NSURL *geoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://open.mapquestapi.com/geocoding/v1/address?key=%@&street=%@&city=Pittsburgh&state=PA&postalCode=%@",apiKey, streetNoSpace, spot.spotZip]];

        NSURLRequest *geoReques = [[NSURLRequest alloc] initWithURL:geoURL];

        [NSURLConnection sendAsynchronousRequest:geoReques queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
            NSDictionary *jsonDictionay = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            [spot addlat:[[jsonDictionay valueForKeyPath:@"results.locations.latLng.lat"] firstObject]
                  andLon:[[jsonDictionay valueForKeyPath:@"results.locations.latLng.lng"] firstObject]];

            NSLog(@"%@", geoURL);

        }];

    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"GeocodeDone" object:self];


}

- (void)geoCodeSingleSpot{


    
}


@end
