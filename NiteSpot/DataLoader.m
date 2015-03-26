//
//  DataLoader.m
//  NiteSpot
//
//  Created by Dan Rudolf on 2/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "DataLoader.h"
#import "Spot.h"

@interface DataLoader ()

@property NSUInteger count;

@end

@implementation DataLoader



- (void)downloadSpots{
    
    self.eatSpotsArray = [NSMutableArray new];
    self.drinkSpotsArray = [NSMutableArray new];
    self.attendSpotsArray = [NSMutableArray new];
    self.allSpotsArray = [NSMutableArray new];
    self.geoDone = NO;


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
                                              thumb:[dictionary objectForKey:@"thumb"]
                                           monHours:@{@"open":[dictionary objectForKey:@"open_Mon"], @"close":[dictionary objectForKey:@"close_Mon"]}
                                           tueHours:@{@"open":[dictionary objectForKey:@"open_Tue"], @"close":[dictionary objectForKey:@"close_Tue"]}
                                           wedHours:@{@"open":[dictionary objectForKey:@"open_Wed"], @"close":[dictionary objectForKey:@"close_Wed"]}
                                           thuHours:@{@"open":[dictionary objectForKey:@"open_Thu"], @"close":[dictionary objectForKey:@"close_Thu"]}
                                           friHours:@{@"open":[dictionary objectForKey:@"open_Fri"], @"close":[dictionary objectForKey:@"close_Fri"]}
                                           satHours:@{@"open":[dictionary objectForKey:@"open_Sat"], @"close":[dictionary objectForKey:@"close_Sat"]}
                                           sunHours:@{@"open":[dictionary objectForKey:@"open_Sun"], @"close":[dictionary objectForKey:@"close_Sun"]}
                                            general:[dictionary objectForKey:@"general"]
                                         monSpecial:@{@"eat": [dictionary objectForKey:@"eat_Mon"], @"drink": [dictionary objectForKey:@"drink_Mon"]}
                                         tueSpecial:@{@"eat": [dictionary objectForKey:@"eat_Tue"], @"drink": [dictionary objectForKey:@"drink_Tue"]}
                                         wedSpecial:@{@"eat": [dictionary objectForKey:@"eat_Wed"], @"drink": [dictionary objectForKey:@"drink_Wed"]}
                                         thuSpecial:@{@"eat": [dictionary objectForKey:@"eat_Thu"], @"drink": [dictionary objectForKey:@"drink_Thu"]}
                                         friSpecial:@{@"eat": [dictionary objectForKey:@"eat_Fri"], @"drink": [dictionary objectForKey:@"drink_Fri"]}
                                         satSpecial:@{@"eat": [dictionary objectForKey:@"eat_Sat"], @"drink": [dictionary objectForKey:@"drink_Sat"]}
                                         sunSpecial:@{@"eat": [dictionary objectForKey:@"eat_Sun"], @"drink": [dictionary objectForKey:@"drink_Sun"]}
                                               menu:[dictionary objectForKey:@"menu"]];


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

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];

        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"hh:mm a"];


        if ([[spot.monHours objectForKey:@"open"] isKindOfClass:[NSNull class]]) {
            spot.monHours = @{@"open": @"Closed", @"close": @"Closed"};

        }

        else{

        NSDate *openMon = [formatter dateFromString:[spot.monHours objectForKey:@"open"]];
        NSString *monOpen = [formatter2 stringFromDate:openMon];
        NSDate *closeMon = [formatter dateFromString:[spot.monHours objectForKey:@"close"]];
        NSString *monClose = [formatter2 stringFromDate:closeMon];

        spot.monHours = @{@"open": monOpen, @"close":monClose};

        }
        
        if ([[spot.tueHours objectForKey:@"open"] isKindOfClass:[NSNull class]]) {
            spot.tueHours = @{@"open": @"Closed", @"close": @"Closed"};

        }

        else{

            NSDate *openTue = [formatter dateFromString:[spot.tueHours objectForKey:@"open"]];
            NSString *tueOpen = [formatter2 stringFromDate:openTue];
            NSDate *closeTue = [formatter dateFromString:[spot.tueHours objectForKey:@"close"]];
            NSString *tueClose = [formatter2 stringFromDate:closeTue];

            spot.tueHours = @{@"open" : tueOpen, @"close" : tueClose};
            
        }

        if ([[spot.wedHours objectForKey:@"open"] isKindOfClass:[NSNull class]]) {
            spot.wedHours = @{@"open": @"Closed", @"close": @"Closed"};

        }

        else{

            NSDate *openWed = [formatter dateFromString:[spot.wedHours objectForKey:@"open"]];
            NSString *wedOpen = [formatter2 stringFromDate:openWed];
            NSDate *closeWed = [formatter dateFromString:[spot.wedHours objectForKey:@"close"]];
            NSString *wedClose = [formatter2 stringFromDate:closeWed];

            spot.wedHours = @{@"open" : wedOpen, @"close" : wedClose};
            
        }

        if ([[spot.thuHours objectForKey:@"open"] isKindOfClass:[NSNull class]]) {
            spot.thuHours = @{@"open": @"Closed", @"close": @"Closed"};

        }

        else{

            NSDate *openThu = [formatter dateFromString:[spot.thuHours objectForKey:@"open"]];
            NSString *thuOpen = [formatter2 stringFromDate:openThu];
            NSDate *closeThu = [formatter dateFromString:[spot.thuHours objectForKey:@"close"]];
            NSString *thuClose = [formatter2 stringFromDate:closeThu];

            spot.thuHours = @{@"open" : thuOpen, @"close" : thuClose};
            
        }

        if ([[spot.friHours objectForKey:@"open"] isKindOfClass:[NSNull class]]) {
            spot.friHours = @{@"open": @"Closed", @"close": @"Closed"};

        }

        else{

            NSDate *openFri = [formatter dateFromString:[spot.friHours objectForKey:@"open"]];
            NSString *friOpen = [formatter2 stringFromDate:openFri];
            NSDate *closeFri = [formatter dateFromString:[spot.friHours objectForKey:@"close"]];
            NSString *friClose = [formatter2 stringFromDate:closeFri];

            spot.friHours = @{@"open" : friOpen, @"close" : friClose};
            
        }

        if ([[spot.satHours objectForKey:@"open"] isKindOfClass:[NSNull class]]) {
            spot.satHours = @{@"open": @"Closed", @"close": @"Closed"};

        }

        else{

            NSDate *openSat = [formatter dateFromString:[spot.satHours objectForKey:@"open"]];
            NSString *satOpen = [formatter2 stringFromDate:openSat];
            NSDate *closeSat = [formatter dateFromString:[spot.satHours objectForKey:@"close"]];
            NSString *satClose = [formatter2 stringFromDate:closeSat];

            spot.satHours = @{@"open" : satOpen, @"close" : satClose};
            
        }
        if ([[spot.sunHours objectForKey:@"open"] isKindOfClass:[NSNull class]]) {
            spot.sunHours = @{@"open": @"Closed", @"close": @"Closed"};

        }

        else{

            NSDate *openSun = [formatter dateFromString:[spot.sunHours objectForKey:@"open"]];
            NSString *sunOpen = [formatter2 stringFromDate:openSun];
            NSDate *closeSun = [formatter dateFromString:[spot.sunHours objectForKey:@"close"]];
            NSString *sunClose = [formatter2 stringFromDate:closeSun];

            spot.sunHours = @{@"open" : sunOpen, @"close" : sunClose};
            
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
  // [self geocodeAllSpots];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadDone" object:self];

}

- (void)geocodeAllSpots{

    NSString *apiKey = @"Fmjtd%7Cluu829u8n5%2Cb2%3Do5-9w1wdy";

   __block NSUInteger count = self.allSpotsArray.count;

        for (Spot *spot in self.allSpotsArray) {

            NSString *streetNoSpace = [spot.spotStreet stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

            NSURL *geoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://open.mapquestapi.com/geocoding/v1/address?key=%@&street=%@&city=Pittsburgh&state=PA&postalCode=%@",apiKey, streetNoSpace, spot.spotZip]];

            NSURLRequest *geoReques = [[NSURLRequest alloc] initWithURL:geoURL];

            [NSURLConnection sendAsynchronousRequest:geoReques queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                NSDictionary *jsonDictionay = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:nil];

                [spot addlat:[[jsonDictionay valueForKeyPath:@"results.locations.latLng.lat"] firstObject]
                      andLon:[[jsonDictionay valueForKeyPath:@"results.locations.latLng.lng"] firstObject]];


                NSLog(@"%@ %@", spot.lat, spot.lon);
                count --;

                if (count == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GeocodeDone"
                                                                        object:self];
                    self.geoDone = YES;
                    NSLog(@"%i",self.geoDone);

                }

            }];

        }

}



@end
