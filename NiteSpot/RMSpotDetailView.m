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
    self.detailContent = [RMSpotDetailContent spotDetailContent];

    [self formatHeader];
    [self geoCodeCurrentSpot];
    [self applySelectors];
    [self callFormats];

    self.detailContent.eatSpecial.layer.borderWidth = 2;
    self.detailContent.eatSpecial.layer.borderColor = [UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1].CGColor;
    self.detailContent.drinkSpecial.layer.borderWidth = 2;
    self.detailContent.drinkSpecial.layer.borderColor = [UIColor colorWithRed:0.267 green:0.267 blue:0.267 alpha:1].CGColor;

    self.contentScroll.delegate = self;
    self.contentScroll.contentSize = CGSizeMake(self.view.frame.size.width, self.detailContent.frame.size.height);

    CGRect sizedFrame = CGRectMake(0, 0, self.view.frame.size.width, self.detailContent.frame.size.height);
    self.detailContent.frame = sizedFrame;
    self.detailContent.aboutTextView.text = self.selectedSpot.spotAbout;

    
    [self.contentScroll addSubview:self.detailContent];
    NSLog(@"%f", self.contentScroll.contentSize.height);


    //NSLog(@"%@ %@ %@ %@ %@ %@", self.selectedSpot.monSpecial, self.selectedSpot.tueSpecial, self.selectedSpot.thuSpecial, self.selectedSpot.friSpecial, self.selectedSpot.satSpecial, self.selectedSpot.sunSpecial);

}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat scale = 1;
    if(self.contentScroll.contentOffset.y<0){
        scale -= self.contentScroll.contentOffset.y/200;
    }

    self.detailContent.detailPhoto.transform = CGAffineTransformMakeScale(scale,scale);
    self.detailContent.detailTitle.transform = CGAffineTransformMakeScale(scale,scale);
    self.detailContent.callButton.transform = CGAffineTransformMakeScale(scale,scale);
    self.detailContent.menuButton.transform = CGAffineTransformMakeScale(scale,scale);
    self.detailContent.webButton.transform = CGAffineTransformMakeScale(scale,scale);

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

#pragma mark - Format View

-(void)callFormats{

    [self formatButton:self.detailContent.callButton];
    [self formatButton:self.detailContent.webButton];
    [self formatButton:self.detailContent.menuButton];
    [self roundViewCorners:self.detailContent.aboutTextView];
    [self roundViewCorners:self.detailContent.aboutView];
    [self roundViewCorners:self.detailContent.specialsContainerView];
    [self roundViewCorners:self.detailContent.specialsInnerContainer];
    [self roundViewCorners:self.detailContent.monSpecialButton];
    [self roundViewCorners:self.detailContent.tueSpecialButton];
    [self roundViewCorners:self.detailContent.wedSpecialButton];
    [self roundViewCorners:self.detailContent.thuSpecialButton];
    [self roundViewCorners:self.detailContent.friSpecialButton];
    [self roundViewCorners:self.detailContent.satSpecialButton];
    [self roundViewCorners:self.detailContent.sunSpecialButton];
    [self roundViewCorners:self.detailContent.eatSpecial];
    [self roundViewCorners:self.detailContent.drinkSpecial];

}

-(void)formatHeader{

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
        self.detailContent.imageContainer.layer.masksToBounds = YES;
        
    }];
}


-(UIButton *)formatButton:(UIButton *)button{

    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = button.layer.frame.size.height/2;
    [[button layer] setBorderWidth:2.0f];
    [[button layer] setBorderColor:[UIColor whiteColor].CGColor];

    return button;
}

-(UIView *)roundViewCorners:(UIView *)view{

    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;

    return view;
}


#pragma mark Outlet Selectors

-(void)applySelectors{

    [self.detailContent.monSpecialButton addTarget:self
                                            action:@selector(onMonPressed)
                                  forControlEvents:UIControlEventTouchUpInside];

    [self.detailContent.tueSpecialButton addTarget:self
                                            action:@selector(onTuesdayPressed)
                                  forControlEvents:UIControlEventTouchUpInside];

    [self.detailContent.wedSpecialButton addTarget:self
                                            action:@selector(onWednesdayPressed)
                                  forControlEvents:UIControlEventTouchUpInside];

    [self.detailContent.thuSpecialButton addTarget:self
                                            action:@selector(onThursdayPressed)
                                  forControlEvents:UIControlEventTouchUpInside];

    [self.detailContent.friSpecialButton addTarget:self
                                            action:@selector(onFridayPressed)
                                  forControlEvents:UIControlEventTouchUpInside];


    [self.detailContent.satSpecialButton addTarget:self
                                            action:@selector(onSaturdayPressed)
                                  forControlEvents:UIControlEventTouchUpInside];

    [self.detailContent.sunSpecialButton addTarget:self
                                            action:@selector(onSundayPressed)
                                  forControlEvents:UIControlEventTouchUpInside];
    [self.detailContent.callButton addTarget:self
                                            action:@selector(onCallPressed)
                                  forControlEvents:UIControlEventTouchUpInside];




}

-(void)onMonPressed{

    self.detailContent.eatSpecial.text = [self.selectedSpot.monSpecial objectForKey:@"eat"];
    self.detailContent.drinkSpecial.text = [self.selectedSpot.monSpecial objectForKey:@"drink"];

    [self animatedSelected:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

}

-(void)onTuesdayPressed{

    self.detailContent.eatSpecial.text = [self.selectedSpot.tueSpecial objectForKey:@"eat"];
    self.detailContent.drinkSpecial.text = [self.selectedSpot.tueSpecial objectForKey:@"drink"];

    [self animatedSelected:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];


}

-(void)onWednesdayPressed{

    self.detailContent.eatSpecial.text = [self.selectedSpot.wedSpecial objectForKey:@"eat"];
    self.detailContent.drinkSpecial.text = [self.selectedSpot.wedSpecial objectForKey:@"drink"];

    [self animatedSelected:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];


}

-(void)onThursdayPressed{

    self.detailContent.eatSpecial.text = [self.selectedSpot.thuSpecial objectForKey:@"eat"];
    self.detailContent.drinkSpecial.text = [self.selectedSpot.thuSpecial objectForKey:@"drink"];

    [self animatedSelected:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

}

-(void)onFridayPressed{

    self.detailContent.eatSpecial.text = [self.selectedSpot.friSpecial objectForKey:@"eat"];
    self.detailContent.drinkSpecial.text = [self.selectedSpot.friSpecial objectForKey:@"drink"];

    [self animatedSelected:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

}

-(void)onSaturdayPressed{

    self.detailContent.eatSpecial.text = [self.selectedSpot.satSpecial objectForKey:@"eat"];
    self.detailContent.drinkSpecial.text = [self.selectedSpot.satSpecial objectForKey:@"drink"];

    [self animatedSelected:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];


}

-(void)onSundayPressed{

    self.detailContent.eatSpecial.text = [self.selectedSpot.sunSpecial objectForKey:@"eat"];
    self.detailContent.drinkSpecial.text = [self.selectedSpot.sunSpecial objectForKey:@"drink"];

    [self animatedSelected:self.detailContent.sunSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];

}

-(void)onCallPressed{
//    NSString *tel = @"4127607595";
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://%@", tel]];

}


#pragma mark - Animations
-(void)animatedSelected:(UIButton *)button{

    if (button.selected == NO) {

    [UIView transitionWithView:button
                      duration:0.10f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        button.backgroundColor = [UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                        [button.layer setBorderWidth:2.0f];
                        [button.layer setBorderColor:[UIColor whiteColor].CGColor];

                        button.selected = YES;
                    }

                    completion:^(BOOL finished) {

                    }];
    }
    else{

        [UIView transitionWithView:button
                          duration:0.10f
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^{

                            //any animatable attribute here.
                            button.backgroundColor = [UIColor whiteColor];
                            [button setTitleColor:[UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1] forState:UIControlStateNormal];
                            [button.layer setBorderWidth:0.0f];

                            button.selected = NO;
                        }
         
                        completion:^(BOOL finished) {
                            
                        }];


    }
}

-(void)resetButton:(UIButton *)button{
    [UIView transitionWithView:button
                      duration:0.10f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        button.backgroundColor = [UIColor whiteColor];
                        [button setTitleColor:[UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1] forState:UIControlStateNormal];
                        [button.layer setBorderWidth:0.0f];

                        button.selected = NO;
                    }

                    completion:^(BOOL finished) {

                    }];


}

@end
