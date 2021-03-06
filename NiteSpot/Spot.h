//
//  Spots.h
//  NiteSpot
//
//  Created by Dan Rudolf on 1/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spot : NSObject

@property NSString *spotID;
@property NSString *spotTitle;
@property NSString *spotType;
@property NSString *spotRegion;
@property NSString *spotCity;
@property NSString *spotStreet;
@property NSString *spotState;
@property NSString *spotZip;
@property NSString *spotAbout;
@property NSString *spotTel;
@property NSString *foodType;
@property NSString *drinkType;
@property NSString *price;
@property NSString *type;
@property NSString *dailySpecial;
@property NSString *foodMon;
@property NSString *foodTue;
@property NSString *foodWed;
@property NSString *foodThu;
@property NSString *foodFri;
@property NSString *foodSat;
@property NSString *foodSun;
@property NSString *drinkMon;
@property NSString *drinkTue;
@property NSString *drinkWed;
@property NSString *drinkThu;
@property NSString *drinkFri;
@property NSString *drinkSat;
@property NSString *drinkSun;
@property NSString *active;
@property NSString *slug;
@property NSString *thumb;
@property NSURL *thumbURL;
@property NSString *lat;
@property NSString *lon;
@property NSDictionary *monHours;
@property NSDictionary *tueHours;
@property NSDictionary *wedHours;
@property NSDictionary *thuHours;
@property NSDictionary *friHours;
@property NSDictionary *satHours;
@property NSDictionary *sunHours;
@property NSDictionary *monSpecial;
@property NSDictionary *tueSpecial;
@property NSDictionary *wedSpecial;
@property NSDictionary *thuSpecial;
@property NSDictionary *friSpecial;
@property NSDictionary *satSpecial;
@property NSDictionary *sunSpecial;
@property NSString *general;
@property NSString *menu;

- (Spot *) initWithName:(NSString *)name
                   type:(NSString *)type
                   idNo:(NSString *)idNo
                 region:(NSString *)region
                   city:(NSString *)city
                 street:(NSString *)street
                  state:(NSString *)state
                    zip:(NSString *)zipCode
                  about:(NSString *)about
                    tel:(NSString *)tel
               foodType:(NSString *)foodType
              drinkType:(NSString *)drinkType
                  price:(NSString *)price
           dailySpecial:(NSString *)daily
                foodMon:(NSString *)foodMon
                foodTue:(NSString *)foodTue
                foodWed:(NSString *)foodWed
                foodThu:(NSString *)foodThu
                foodFri:(NSString *)foodFri
                foodSat:(NSString *)foodSat
                foodSun:(NSString *)foodSun
               drinkMon:(NSString *)drinMon
               drinkTue:(NSString *)drinkTue
               drinkWed:(NSString *)drinkWed
               drinkThu:(NSString *)drinkThu
               drinkFri:(NSString *)drinkFri
               drinkSat:(NSString *)drinkSat
               drinkSun:(NSString *)drinkSun
                   slug:(NSString *)slug
                  thumb:(NSString *)thumb
               monHours:(NSDictionary *)monHours
               tueHours:(NSDictionary *)tueHours
               wedHours:(NSDictionary *)wedHours
               thuHours:(NSDictionary *)thuHours
               friHours:(NSDictionary *)firHours
               satHours:(NSDictionary *)satHours
               sunHours:(NSDictionary *)sunHours
                general:(NSString *)general
             monSpecial:(NSDictionary *)monSpecial
             tueSpecial:(NSDictionary *)tueSpecial
             wedSpecial:(NSDictionary *)wedSpecial
             thuSpecial:(NSDictionary *)thuSpecial
             friSpecial:(NSDictionary *)friSpecial
             satSpecial:(NSDictionary *)satSpecial
             sunSpecial:(NSDictionary *)sunSpecial
                   menu:(NSString *)menu;

- (Spot *) addThumbURL:(NSURL *)url;

-(Spot *) addlat:(NSArray *)lat andLon:(NSArray *)lon;


@end
