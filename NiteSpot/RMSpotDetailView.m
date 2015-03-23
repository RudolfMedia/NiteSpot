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

@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;
@property RMSpotDetailContent *detailContent;

@property UIScrollView *specialsContent;


@end

@implementation RMSpotDetailView

- (void)viewDidLoad {

    [super viewDidLoad];
    [self geoCodeCurrentSpot];

    self.contentScroll.delegate = self;
    self.detailContent = [RMSpotDetailContent spotDetailContent];
    self.contentScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.detailContent.frame.size.height);
    CGRect sizedFrame = CGRectMake(0, 0, self.view.frame.size.width, self.detailContent.frame.size.height);
    self.detailContent.frame = sizedFrame;
    [self formatButton:self.detailContent.callButton];
    [self formatButton:self.detailContent.webButton];
    [self formatButton:self.detailContent.menuButton];

    
    [self.contentScroll addSubview:self.detailContent];
    NSLog(@"%f", self.contentScroll.contentSize.height);


    //NSLog(@"%@ %@ %@ %@ %@ %@", self.selectedSpot.monSpecial, self.selectedSpot.tueSpecial, self.selectedSpot.thuSpecial, self.selectedSpot.friSpecial, self.selectedSpot.satSpecial, self.selectedSpot.sunSpecial);

    if ([self.selectedSpot.type isEqualToString:@"a"]) {

        self.detailContent.detailImageTwo.image = [UIImage imageNamed:@"detailEat"];
        self.detailContent.detailTwoLabel.text = @"Food";
        [self.detailContent.detailImageOne setHidden:YES];
        [self.detailContent.detailImageThree setHidden:YES];
        [self.detailContent.detailOneLabel setHidden:YES];
        [self.detailContent.detailThreeLabel setHidden:YES];

    }

    else if ([self.selectedSpot.type isEqualToString:@"b"]){

        self.detailContent.detailImageTwo.image = [UIImage imageNamed:@"detailDrink"];
        self.detailContent.detailTwoLabel.text = @"Drinks";
        [self.detailContent.detailImageOne setHidden:YES];
        [self.detailContent.detailImageThree setHidden:YES];
        [self.detailContent.detailOneLabel setHidden:YES];
        [self.detailContent.detailThreeLabel setHidden:YES];

    }

    else if ([self.selectedSpot.type isEqualToString:@"c"]){

        self.detailContent.detailImageOne.image = [UIImage imageNamed:@"detailEat"];
        self.detailContent.detailImageThree.image = [UIImage imageNamed:@"detailDrink"];
        self.detailContent.detailOneLabel.text = @"Food";
        self.detailContent.detailThreeLabel.text = @"Drinks";
        [self.detailContent.detailImageTwo setHidden:YES];
        [self.detailContent.detailTwoLabel setHidden:YES];
        
    }

    NSLog(@"%@", self.selectedSpot.type);



    self.detailContent.detailTitle.text = self.selectedSpot.spotTitle;

    self.detailContent.detailInfoString.text = [NSString stringWithFormat:@"%@ \u2022 %@",
                                  self.selectedSpot.foodType,
                                  self.selectedSpot.drinkType];

    self.detailContent.detailPricePhone.text = [NSString stringWithFormat:@"%@ \u2022 %@",
                                  self.selectedSpot.price,
                                  self.selectedSpot.spotTel];


    GPUImageiOSBlurFilter *iosBlur = [[GPUImageiOSBlurFilter alloc] init];
    iosBlur.blurRadiusInPixels = 1;

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.selectedSpot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        UIImage *image = [UIImage imageWithData:data];
        self.detailContent.detailPhoto.image = [iosBlur imageByFilteringImage:image];
        self.detailContent.detailPhoto.layer.masksToBounds = YES;

    }];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat scale = 1;
    if(self.contentScroll.contentOffset.y<0){
        scale -= self.contentScroll.contentOffset.y/250;
    }

    self.detailContent.detailPhoto.transform = CGAffineTransformMakeScale(scale,scale);
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
    button.layer.cornerRadius = button.layer.frame.size.height/2;
    [[button layer] setBorderWidth:2.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];

    return button;
}


@end
