//
//  RMSpotDetailView.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/20/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMSpotDetailView.h"
#import "RMSpotDetailContent.h"
#import "MapBox.h"


@interface RMSpotDetailView () <UIBarPositioningDelegate, UITextViewDelegate, RMMapViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *detailPhoto;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailinfoString;
@property (weak, nonatomic) IBOutlet UILabel *detailPricePhone;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;

@property UIScrollView *specialsContent;


@end

@implementation RMSpotDetailView

- (void)viewDidLoad {

    [super viewDidLoad];
    [self geoCodeCurrentSpot];

    self.contentScroll.delegate = self;

    RMSpotDetailContent *detailContent = [RMSpotDetailContent spotDetailContent];
    self.contentScroll.contentSize = CGSizeMake(self.view.frame.size.width, detailContent.frame.size.height);

    
    [self.contentScroll addSubview:detailContent];
    NSLog(@"%f", self.contentScroll.contentSize.height);


    //NSLog(@"%@ %@ %@ %@ %@ %@", self.selectedSpot.monSpecial, self.selectedSpot.tueSpecial, self.selectedSpot.thuSpecial, self.selectedSpot.friSpecial, self.selectedSpot.satSpecial, self.selectedSpot.sunSpecial);

    self.detailPhoto.backgroundColor = [UIColor blackColor];

    if ([self.selectedSpot.type isEqualToString:@"a"]) {

        self.detailTypeImage.image = [UIImage imageNamed:@"detailEat"];

    }

    else if ([self.selectedSpot.type isEqualToString:@"b"]){

        self.detailTypeImage.image = [UIImage imageNamed:@"detailDrink"];

    }

    else if ([self.selectedSpot.type isEqualToString:@"c"]){

        self.detailTypeImage.image = [UIImage imageNamed:@"eatDrinkDetail"];
        
    }



    self.detailTitle.text = self.selectedSpot.spotTitle;

    self.detailinfoString.text = [NSString stringWithFormat:@"%@ \u2022 %@",
                                  self.selectedSpot.foodType,
                                  self.selectedSpot.drinkType];

    self.detailPricePhone.text = [NSString stringWithFormat:@"%@ \u2022 %@",
                                  self.selectedSpot.price,
                                  self.selectedSpot.spotTel];


    GPUImageiOSBlurFilter *iosBlur = [[GPUImageiOSBlurFilter alloc] init];
    iosBlur.blurRadiusInPixels = 1;

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.selectedSpot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        UIImage *image = [UIImage imageWithData:data];
        self.detailPhoto.image = [iosBlur imageByFilteringImage:image];

    }];

}


-(void)geoCodeCurrentSpot{

    NSString *apiKey = @"Fmjtd%7Cluu829u8n5%2Cb2%3Do5-9w1wdy";
    NSString *streetNoSpace = [self.selectedSpot.spotStreet stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *geoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://open.mapquestapi.com/geocoding/v1/address?key=%@&street=%@&city=Pittsburgh&state=PA&postalCode=%@",apiKey, streetNoSpace, self.selectedSpot.spotZip]];
    NSURLRequest *geoReques = [[NSURLRequest alloc] initWithURL:geoURL];

    [NSURLConnection sendAsynchronousRequest:geoReques queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *jsonDictionay = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:nil];

        [self.selectedSpot addlat:[[jsonDictionay valueForKeyPath:@"results.locations.latLng.lat"] firstObject]
              andLon:[[jsonDictionay valueForKeyPath:@"results.locations.latLng.lng"] firstObject]];
        NSLog(@"%@ %@", self.selectedSpot.lat, self.selectedSpot.lon);
    }];

}



-(UIButton *)formatButton:(UIButton *)button{

    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    return button;
}


@end
