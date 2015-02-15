//
//  DataLoader.h
//  NiteSpot
//
//  Created by Dan Rudolf on 2/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataLoader : NSObject

@property NSDictionary *spotJSONDictionary;
@property NSMutableArray *eatSpotsArray;
@property NSMutableArray *drinkSpotsArray;
@property NSMutableArray *attendSpotsArray;
@property NSMutableArray *allSpotsArray;
@property BOOL geoDone;


-(void)downloadSpots;


@end
