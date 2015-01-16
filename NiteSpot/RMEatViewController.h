//
//  ViewController.h
//  NiteSpot
//
//  Created by Dan Rudolf on 1/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMEatViewController : UIViewController

@property NSArray *spotJSONArray;
@property NSMutableArray *eatSpotsArray;
@property NSMutableArray *drinkSpotsArray;
@property NSMutableArray *attendSpotsArray;
@property NSString *apiKey;


@end

