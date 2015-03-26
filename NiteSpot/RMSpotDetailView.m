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
#import "RMWebView.h"


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
    [self displayHours];
    [self setCurrentDay];
    [self.detailContent.webButton setEnabled:NO];

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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setUpMapView)
                                                 name:@"SingleSpotDone"
                                               object:nil];


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

        [[NSNotificationCenter defaultCenter] postNotificationName:@"SingleSpotDone" object:self];

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
    [self roundViewCorners:self.detailContent.locationContainer];
    [self roundViewCorners:self.detailContent.locationMapContainer];
    [self roundViewCorners:self.detailContent.hoursView];
    [self roundViewCorners:self.detailContent.hoursContainer];

    [self menuButtonLogic:self.detailContent.menuButton];
    [self callButtonLogic:self.detailContent.callButton];
    [self webButtonLogic:self.detailContent.webButton];

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

- (void)setUpMapView{

    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoicnVkb2xmbWVkaWEiLCJhIjoidDZSa2hYcyJ9.ucXq4hJcdZTuInE-gtM0ug"];
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"rudolfmedia.kpbaioeo"];

    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.detailContent.locationMapContainer.bounds andTilesource:tileSource];

    [self.detailContent.locationMapContainer addSubview:mapView];
    mapView.delegate = self;
    mapView.tintColor = [UIColor lightGrayColor];
    mapView.clusteringEnabled = YES;
    mapView.zoom = 14;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.4397, -79.9764)];
    mapView.tintColor = [UIColor blackColor];
    CLLocationCoordinate2D zoomCenter = CLLocationCoordinate2DMake([self.selectedSpot.lat floatValue], [self.selectedSpot.lon floatValue]);

    [mapView setCenterCoordinate:zoomCenter];

    RMPointAnnotation *singleAnnotation = [[RMPointAnnotation alloc] initWithMapView:mapView coordinate:zoomCenter andTitle:self.selectedSpot.spotTitle];

    [mapView addAnnotation:singleAnnotation];

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
    [self.detailContent.menuButton addTarget:self
                                      action:@selector(onMenuePressed)
                            forControlEvents:UIControlEventTouchUpInside];




}

-(void)onMonPressed{

    [self animateView:self.detailContent.eatSpecial];
    [self animateView:self.detailContent.drinkSpecial];
    [self animateView:self.detailContent.eatSpecialImage];
    [self animateView:self.detailContent.drinkSpecialImage];

    [self displaySpecial:self.selectedSpot.monSpecial];

    [self animatedSelected:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

    [self noSpecialsWeekLogic:self.selectedSpot.monSpecial
                          tue:self.selectedSpot.tueSpecial
                          wed:self.selectedSpot.wedSpecial
                          thu:self.selectedSpot.thuSpecial
                          fri:self.selectedSpot.friSpecial
                          sat:self.selectedSpot.satSpecial
                          sun:self.selectedSpot.sunSpecial];



}

-(void)onTuesdayPressed{

    [self animateView:self.detailContent.eatSpecial];
    [self animateView:self.detailContent.drinkSpecial];
    [self animateView:self.detailContent.eatSpecialImage];
    [self animateView:self.detailContent.drinkSpecialImage];

    [self displaySpecial:self.selectedSpot.tueSpecial];

    [self animatedSelected:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

    [self noSpecialsWeekLogic:self.selectedSpot.monSpecial
                          tue:self.selectedSpot.tueSpecial
                          wed:self.selectedSpot.wedSpecial
                          thu:self.selectedSpot.thuSpecial
                          fri:self.selectedSpot.friSpecial
                          sat:self.selectedSpot.satSpecial
                          sun:self.selectedSpot.sunSpecial];




}

-(void)onWednesdayPressed{

    [self animateView:self.detailContent.eatSpecial];
    [self animateView:self.detailContent.drinkSpecial];
    [self animateView:self.detailContent.eatSpecialImage];
    [self animateView:self.detailContent.drinkSpecialImage];

    [self displaySpecial:self.selectedSpot.wedSpecial];

    [self animatedSelected:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

    [self noSpecialsWeekLogic:self.selectedSpot.monSpecial
                          tue:self.selectedSpot.tueSpecial
                          wed:self.selectedSpot.wedSpecial
                          thu:self.selectedSpot.thuSpecial
                          fri:self.selectedSpot.friSpecial
                          sat:self.selectedSpot.satSpecial
                          sun:self.selectedSpot.sunSpecial];


}

-(void)onThursdayPressed{

    [self animateView:self.detailContent.eatSpecial];
    [self animateView:self.detailContent.drinkSpecial];
    [self animateView:self.detailContent.eatSpecialImage];
    [self animateView:self.detailContent.drinkSpecialImage];

     [self displaySpecial:self.selectedSpot.thuSpecial];

    [self animatedSelected:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

    [self noSpecialsWeekLogic:self.selectedSpot.monSpecial
                          tue:self.selectedSpot.tueSpecial
                          wed:self.selectedSpot.wedSpecial
                          thu:self.selectedSpot.thuSpecial
                          fri:self.selectedSpot.friSpecial
                          sat:self.selectedSpot.satSpecial
                          sun:self.selectedSpot.sunSpecial];



}

-(void)onFridayPressed{

    [self animateView:self.detailContent.eatSpecial];
    [self animateView:self.detailContent.drinkSpecial];
    [self animateView:self.detailContent.eatSpecialImage];
    [self animateView:self.detailContent.drinkSpecialImage];

     [self displaySpecial:self.selectedSpot.friSpecial];

    [self animatedSelected:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

    [self noSpecialsWeekLogic:self.selectedSpot.monSpecial
                          tue:self.selectedSpot.tueSpecial
                          wed:self.selectedSpot.wedSpecial
                          thu:self.selectedSpot.thuSpecial
                          fri:self.selectedSpot.friSpecial
                          sat:self.selectedSpot.satSpecial
                          sun:self.selectedSpot.sunSpecial];

}

-(void)onSaturdayPressed{

    [self animateView:self.detailContent.eatSpecial];
    [self animateView:self.detailContent.drinkSpecial];
    [self animateView:self.detailContent.eatSpecialImage];
    [self animateView:self.detailContent.drinkSpecialImage];

     [self displaySpecial:self.selectedSpot.satSpecial];

    [self animatedSelected:self.detailContent.satSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.sunSpecialButton];

    [self noSpecialsWeekLogic:self.selectedSpot.monSpecial
                          tue:self.selectedSpot.tueSpecial
                          wed:self.selectedSpot.wedSpecial
                          thu:self.selectedSpot.thuSpecial
                          fri:self.selectedSpot.friSpecial
                          sat:self.selectedSpot.satSpecial
                          sun:self.selectedSpot.sunSpecial];

}

-(void)onSundayPressed{

    [self animateView:self.detailContent.eatSpecial];
    [self animateView:self.detailContent.drinkSpecial];
    [self animateView:self.detailContent.eatSpecialImage];
    [self animateView:self.detailContent.drinkSpecialImage];

    [self displaySpecial:self.selectedSpot.sunSpecial];

    [self animatedSelected:self.detailContent.sunSpecialButton];
    [self resetButton:self.detailContent.monSpecialButton];
    [self resetButton:self.detailContent.tueSpecialButton];
    [self resetButton:self.detailContent.wedSpecialButton];
    [self resetButton:self.detailContent.thuSpecialButton];
    [self resetButton:self.detailContent.friSpecialButton];
    [self resetButton:self.detailContent.satSpecialButton];

    [self noSpecialsWeekLogic:self.selectedSpot.monSpecial
                          tue:self.selectedSpot.tueSpecial
                          wed:self.selectedSpot.wedSpecial
                          thu:self.selectedSpot.thuSpecial
                          fri:self.selectedSpot.friSpecial
                          sat:self.selectedSpot.satSpecial
                          sun:self.selectedSpot.sunSpecial];


}

-(void)onCallPressed{
    NSString *telString = [NSString stringWithFormat:@"telprompt://%@", self.selectedSpot.spotTel];
    NSString *whiteSpace = [telString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *dash = [whiteSpace stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSURL *tel = [NSURL URLWithString:dash];
    [[UIApplication sharedApplication] openURL:tel];

}

-(void)onMenuePressed{

   // RMWebView *webView = [[RMWebView alloc] init];

    [self performSegueWithIdentifier:@"WEBVIEW" sender:self];

}

#pragma mark - Segue Delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"WEBVIEW"]) {

        RMWebView *webview = [segue destinationViewController];
        webview.menu = self.selectedSpot.menu;
    }

    
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

-(void)animateView:(UIView *)view{

    view.alpha = 0;
    [UIView transitionWithView:view
                      duration:0.3f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        view.alpha = 1;
                    }

                    completion:^(BOOL finished) {
                        
                    }];


}

#pragma mark - Display Logic 


-(void)displaySpecial:(NSDictionary *)daySpecial{


    if ([[daySpecial objectForKey:@"eat"] length] < 2){
        [self animateView:self.detailContent.noFoodIndicator];
        [self.detailContent.noFoodIndicator setHidden:NO];
        [self.detailContent.eatSpecial setHidden:YES];
        [self.detailContent.eatSpecialImage setHidden:YES];
    }
    else{

        [self.detailContent.eatSpecial setHidden:NO];
        [self.detailContent.noFoodIndicator setHidden:YES];
        self.detailContent.eatSpecial.text = [daySpecial objectForKey:@"eat"];
        [self.detailContent.eatSpecialImage setHidden:NO];

    }



    if ([[daySpecial objectForKey:@"drink"] length] < 2) {

        [self animateView:self.detailContent.noDrinkIndicator];
        [self.detailContent.drinkSpecial setHidden:YES];
        [self.detailContent.noDrinkIndicator setHidden:NO];
        [self.detailContent.drinkSpecialImage setHidden:YES];

    }
    else{

        [self.detailContent.drinkSpecial setHidden:NO];
        [self.detailContent.noDrinkIndicator setHidden:YES];
        [self.detailContent.drinkSpecialImage setHidden:NO];
        self.detailContent.drinkSpecial.text = [daySpecial objectForKey:@"drink"];

    }

}

-(void)displayHours{

    [self setHours:self.selectedSpot.monHours forLabel:self.detailContent.hoursMon];
    [self setHours:self.selectedSpot.tueHours forLabel:self.detailContent.hoursTue];
    [self setHours:self.selectedSpot.wedHours forLabel:self.detailContent.hoursWed];
    [self setHours:self.selectedSpot.thuHours forLabel:self.detailContent.hoursThurs];
    [self setHours:self.selectedSpot.friHours forLabel:self.detailContent.hoursFri];
    [self setHours:self.selectedSpot.satHours forLabel:self.detailContent.hoursSat];
    [self setHours:self.selectedSpot.sunHours forLabel:self.detailContent.hoursSun];
}

-(void)setHours:(NSDictionary *)hours forLabel:(UILabel *)label{

    NSString *closedString = @"Closed";

    if ([[hours objectForKey:@"open"] isEqualToString:closedString]){
        label.text = closedString;
    }

    else{
        label.text = [NSString stringWithFormat:@"%@ - %@", [hours objectForKey:@"open"], [hours objectForKey:@"close"]];
    }
}

-(void)setCurrentDay{

    NSDateFormatter *currentDay = [[NSDateFormatter alloc] init];
    [currentDay setDateFormat:@"EEEE"];

    if ([[currentDay stringFromDate:[NSDate date]] isEqualToString:@"Monday"]) {
        [self onMonPressed];
    }

    else if ([[currentDay stringFromDate:[NSDate date]] isEqualToString:@"Tuesday"]){
        [self onTuesdayPressed];
    }

    else if ([[currentDay stringFromDate:[NSDate date]] isEqualToString:@"Wednesday"]){
        [self onWednesdayPressed];
    }

    else if ([[currentDay stringFromDate:[NSDate date]] isEqualToString:@"Thursday"]){
        [self onThursdayPressed];
    }

    else if ([[currentDay stringFromDate:[NSDate date]] isEqualToString:@"Friday"]){
        [self onFridayPressed];
    }
    else if ([[currentDay stringFromDate:[NSDate date]] isEqualToString:@"Saturday"]){
        [self onSaturdayPressed];
    }
    else if ([[currentDay stringFromDate:[NSDate date]] isEqualToString:@"Sunday"]){
        [self onSundayPressed];
    }

}

-(void)noSpecialsWeekLogic:(NSDictionary *)mon tue:(NSDictionary *)tue wed:(NSDictionary *)wed thu:(NSDictionary *)thu fri:(NSDictionary *)fri sat:(NSDictionary *)sat sun:(NSDictionary *)sun{

    if ([[mon objectForKey:@"eat"] length] <2  && [[mon objectForKey:@"drink"] length ] < 2 &&
        [[tue objectForKey:@"eat"] length] <2  && [[tue objectForKey:@"drink"] length ] < 2 &&
        [[wed objectForKey:@"eat"] length] <2  && [[wed objectForKey:@"drink"] length ] < 2 &&
        [[thu objectForKey:@"eat"] length] <2  && [[thu objectForKey:@"drink"] length ] < 2 &&
        [[fri objectForKey:@"eat"] length] <2  && [[fri objectForKey:@"drink"] length ] < 2 &&
        [[sat objectForKey:@"eat"] length] <2  && [[sat objectForKey:@"drink"] length ] < 2 &&
        [[sun objectForKey:@"eat"] length] <2  && [[sun objectForKey:@"drink"] length ] < 2) {

        [self.detailContent.eatSpecial setHidden:YES];
        [self.detailContent.drinkSpecial setHidden:YES];
        [self.detailContent.eatSpecialImage setHidden:YES];
        [self.detailContent.drinkSpecialImage setHidden:YES];
        [self.detailContent.noFoodIndicator setHidden:YES];
        [self.detailContent.noDrinkIndicator setHidden:YES];

//        [self.detailContent.monSpecialButton setEnabled:NO];
//        [self.detailContent.tueSpecialButton setEnabled:NO];
//        [self.detailContent.wedSpecialButton setEnabled:NO];
//        [self.detailContent.thuSpecialButton setEnabled:NO];
//        [self.detailContent.friSpecialButton setEnabled:NO];
//        [self.detailContent.satSpecialButton setEnabled:NO];
//        [self.detailContent.sunSpecialButton setEnabled:NO];

    }
    else{

        [self.detailContent.noSpecialsWeek setHidden:YES];
    }


}

-(void)callButtonLogic:(UIButton *)button{

    if (self.selectedSpot.spotTel.length < 10) {

        [button setEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"callDisabled"] forState:UIControlStateDisabled];
    }

}

#warning must impliment when json changes
-(void)webButtonLogic:(UIButton *)button{

    [button setEnabled:NO];
    [button setBackgroundColor:[UIColor colorWithRed:0.533 green:0.522 blue:0.522 alpha:1]];
    
}

-(void)menuButtonLogic:(UIButton *)button{

    if (self.selectedSpot.menu.length < 7) {
        [button setEnabled:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"menuDisabled"] forState:UIControlStateDisabled];

    }
    
}





@end
