//
//  Spots.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "Spot.h"

@implementation Spot

-(Spot *) initWithName:(NSString *)name type:(NSString *)type idNo:(NSString *)idNo region:(NSString *)region city:(NSString *)city street:(NSString *)street state:(NSString *)state zip:(NSString *)zipCode about:(NSString *)about tel:(NSString *)tel foodType:(NSString *)foodType drinkType:(NSString *)drinkType price:(NSString *)price dailySpecial:(NSString *)daily foodMon:(NSString *)foodMon foodTue:(NSString *)foodTue foodWed:(NSString *)foodWed foodThu:(NSString *)foodThu foodFri:(NSString *)foodFri foodSat:(NSString *)foodSat foodSun:(NSString *)foodSun drinkMon:(NSString *)drinMon drinkTue:(NSString *)drinkTue drinkWed:(NSString *)drinkWed drinkThu:(NSString *)drinkThu drinkFri:(NSString *)drinkFri drinkSat:(NSString *)drinkSat drinkSun:(NSString *)drinkSun thumbURl:(NSURL *)thumUrl{

    self.spotTitle = name;
    self.spotType = type;
    self.spotID = idNo;
    self.spotRegion = region;
    self.spotCity = city;
    self.spotStreet = street;
    self.spotState = state;
    self.spotZip = zipCode;
    self.spotAbout = about;
    self.spotTel = tel;
    self.foodType = foodType;
    self.drinkType = drinkType;
    self.price = price;
    self.dailySpecial = daily;
    self.foodMon = foodMon;
    self.foodTue = foodTue;
    self.foodWed = foodWed;
    self.foodThu = foodThu;
    self.foodFri = foodFri;
    self.foodSat = foodSat;
    self.foodSun = foodSun;
    self.drinkMon = drinMon;
    self.drinkTue = drinkTue;
    self.drinkWed = drinkWed;
    self.drinkThu = drinkThu;
    self.drinkFri = drinkFri;
    self.drinkSat = drinkSat;
    self.drinkSun = drinkSun;
    self.thumbURL = thumUrl;

    return self;
}

@end
