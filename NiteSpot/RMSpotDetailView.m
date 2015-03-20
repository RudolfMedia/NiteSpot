//
//  RMSpotDetailView.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/20/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMSpotDetailView.h"
#import "AboutCell.h"
#import "LocationCell.h"
#import "HoursCell.h"
#import "SpecialsCell.h"

@interface RMSpotDetailView () <UICollectionViewDataSource, UIBarPositioningDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, RMMapViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *detailPhoto;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailinfoString;
@property (weak, nonatomic) IBOutlet UILabel *detailPricePhone;
@property (weak, nonatomic) IBOutlet UIButton *detailAbout;
@property (weak, nonatomic) IBOutlet UIButton *detailSpecials;
@property (weak, nonatomic) IBOutlet UIButton *detailHours;

@property (weak, nonatomic) IBOutlet UICollectionView *detailCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *detailLocation;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLable;

@property CLLocationCoordinate2D *currentLocation;
@property CLLocationManager *locationManager;
@property UICollectionViewFlowLayout *flowLayout;
@property UIScrollView *specialsContent;


@end

@implementation RMSpotDetailView

- (void)viewDidLoad {

    [super viewDidLoad];
    [self geoCodeCurrentSpot];

    self.detailCollectionView.delegate = self;

    NSLog(@"%@", self.selectedSpot.type);


    [self formatButton:self.detailAbout];
    [self formatButton:self.detailLocation];
    [self formatButton:self.detailSpecials];
    [self formatButton:self.detailHours];

    NSLog(@"%@ %@ %@ %@ %@ %@", self.selectedSpot.monSpecial, self.selectedSpot.tueSpecial, self.selectedSpot.thuSpecial, self.selectedSpot.friSpecial, self.selectedSpot.satSpecial, self.selectedSpot.sunSpecial);

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
    self.detailCollectionView.scrollEnabled = NO;
    

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.selectedSpot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        UIImage *image = [UIImage imageWithData:data];
        self.detailPhoto.image = [iosBlur imageByFilteringImage:image];

    }];

}

-(void)viewWillAppear:(BOOL)animated{

    [self.detailCollectionView registerNib:[UINib nibWithNibName:@"AboutCell"
                                                          bundle:[NSBundle mainBundle]]
                                      forCellWithReuseIdentifier:@"AboutCell"];

    [self.detailCollectionView registerNib:[UINib nibWithNibName:@"HoursCell"
                                                          bundle:[NSBundle mainBundle]]
                                      forCellWithReuseIdentifier:@"HoursCell"];


    [self.detailCollectionView registerNib:[UINib nibWithNibName:@"SpecialsCell"
                                                          bundle:[NSBundle mainBundle]]
                forCellWithReuseIdentifier:@"SpecialsCell"];

    [self.detailCollectionView registerClass:[LocationCell class]
                  forCellWithReuseIdentifier:@"LocationCell"];

}

#pragma mark - UItableview Datasource/ Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpecialDetailCell"];
    cell.textLabel.text = @"derp";
    return cell;
}

#pragma mark - UICollectionview Datasource / Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize cellSize = CGSizeMake(self.detailCollectionView.frame.size.width,
                                 self.detailCollectionView.frame.size.height);
    return cellSize;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 4;

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AboutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AboutCell" forIndexPath:indexPath];
    UITextView *textView = (UITextView *)[cell viewWithTag:100];
    textView.text = self.selectedSpot.spotAbout;

    if (indexPath == [NSIndexPath indexPathForItem:0 inSection:0]) {

        AboutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AboutCell" forIndexPath:indexPath];
        UITextView *textView = (UITextView *)[cell viewWithTag:100];
        textView.text = self.selectedSpot.spotAbout;


        return cell;

    }
    else if(indexPath == [NSIndexPath indexPathForItem:1 inSection:0]){

        LocationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocationCell" forIndexPath:indexPath];

        [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoicnVkb2xmbWVkaWEiLCJhIjoidDZSa2hYcyJ9.ucXq4hJcdZTuInE-gtM0ug"];
        RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"rudolfmedia.kpbaioeo"];

        RMMapView *mapView = [[RMMapView alloc] initWithFrame:cell.bounds andTilesource:tileSource];

        [cell addSubview:mapView];
        mapView.delegate = self;
        mapView.tintColor = [UIColor lightGrayColor];
        mapView.clusteringEnabled = YES;
        mapView.zoom = 13;

        CLLocationCoordinate2D zoomCenter = CLLocationCoordinate2DMake([self.selectedSpot.lat floatValue], [self.selectedSpot.lon floatValue]);

        [mapView setCenterCoordinate:zoomCenter];

        RMPointAnnotation *singleAnnotation = [[RMPointAnnotation alloc] initWithMapView:mapView coordinate:zoomCenter andTitle:self.selectedSpot.spotTitle];

        [mapView addAnnotation:singleAnnotation];

        return cell;
      
    }

    else if (indexPath == [NSIndexPath indexPathForItem:2 inSection:0]){

        SpecialsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpecialsCell" forIndexPath:indexPath];
        self.specialsContent = (UIScrollView *)[cell viewWithTag:60];
        self.specialsContent.delegate = self;

        UIView *container = (UIView *)[cell viewWithTag:1001];
        [container addConstraint:[NSLayoutConstraint constraintWithItem:container
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.height]];


        UIView *monView = (UIView *)[cell viewWithTag:1001];
        [monView addConstraint:[NSLayoutConstraint constraintWithItem:monView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.width]];

        UIView *tueView = (UIView *)[cell viewWithTag:2001];
        [tueView addConstraint:[NSLayoutConstraint constraintWithItem:tueView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.width]];

        UIView *wedView = (UIView *)[cell viewWithTag:3001];
        [wedView addConstraint:[NSLayoutConstraint constraintWithItem:wedView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.width]];

        UIView *thuView = (UIView *)[cell viewWithTag:4001];
        [thuView addConstraint:[NSLayoutConstraint constraintWithItem:thuView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.width]];

        UIView *friView = (UIView *)[cell viewWithTag:5001];
        [friView addConstraint:[NSLayoutConstraint constraintWithItem:friView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.width]];

        UIView *satView = (UIView *)[cell viewWithTag:6001];
        [satView addConstraint:[NSLayoutConstraint constraintWithItem:satView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.width]];
        UIView *sunView = (UIView *)[cell viewWithTag:7001];
        [sunView addConstraint:[NSLayoutConstraint constraintWithItem:sunView
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0f constant:collectionView.frame.size.width]];


        return cell;

    }

    else if (indexPath == [NSIndexPath indexPathForItem:3 inSection:0]){
        HoursCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HoursCell" forIndexPath:indexPath];
        UILabel *mon = (UILabel *)[cell viewWithTag:1000];
        UILabel *tue = (UILabel *)[cell viewWithTag:2000];
        UILabel *wed = (UILabel *)[cell viewWithTag:3000];
        UILabel *thu = (UILabel *)[cell viewWithTag:4000];
        UILabel *fri = (UILabel *)[cell viewWithTag:5000];
        UILabel *sat = (UILabel *)[cell viewWithTag:6000];
        UILabel *sun = (UILabel *)[cell viewWithTag:7000];
        UIScrollView *content = (UIScrollView *)[cell viewWithTag:60];
        content.delegate = self;
        NSString *closedString = @"Closed";

        if ([[self.selectedSpot.monHours objectForKey:@"open"] isEqualToString:closedString]) {
            mon.text = closedString;
        }
        else{
        mon.text = [NSString stringWithFormat:@"%@ - %@",[self.selectedSpot.monHours objectForKey:@"open"], [self.selectedSpot.monHours objectForKey:@"close"]];
        }
        if ([[self.selectedSpot.tueHours objectForKey:@"open"] isEqualToString:closedString]) {
            tue.text = closedString;
        }
        else{

        tue.text = [NSString stringWithFormat:@"%@ - %@",[self.selectedSpot.tueHours objectForKey:@"open"], [self.selectedSpot.tueHours objectForKey:@"close"]];
        }

        if ([[self.selectedSpot.wedHours objectForKey:@"open"] isEqualToString:closedString]) {
            wed.text = closedString;
        }
        else{
        wed.text = [NSString stringWithFormat:@"%@ - %@",[self.selectedSpot.wedHours objectForKey:@"open"], [self.selectedSpot.wedHours objectForKey:@"close"]];
        }
        if ([[self.selectedSpot.thuHours objectForKey:@"open"] isEqualToString:closedString]) {
            thu.text = closedString;
        }
        else{
        thu.text = [NSString stringWithFormat:@"%@ - %@",[self.selectedSpot.thuHours objectForKey:@"open"], [self.selectedSpot.thuHours objectForKey:@"close"]];
        }
        if ([[self.selectedSpot.friHours objectForKey:@"open"] isEqualToString:closedString]) {
            fri.text = closedString;
        }
        else{
        fri.text = [NSString stringWithFormat:@"%@ - %@",[self.selectedSpot.friHours objectForKey:@"open"], [self.selectedSpot.friHours objectForKey:@"close"]];
        }
        if ([[self.selectedSpot.satHours objectForKey:@"open"] isEqualToString:closedString]) {
            sat.text = closedString;
        }
        else{
        sat.text = [NSString stringWithFormat:@"%@ - %@",[self.selectedSpot.satHours objectForKey:@"open"], [self.selectedSpot.satHours objectForKey:@"close"]];
        }
        if ([[self.selectedSpot.sunHours objectForKey:@"open"] isEqualToString:closedString]) {
            sun.text = closedString;
        }
        else{
        sun.text = [NSString stringWithFormat:@"%@ - %@",[self.selectedSpot.sunHours objectForKey:@"open"], [self.selectedSpot.sunHours objectForKey:@"close"]];
        }


        return cell;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", indexPath);
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

- (IBAction)onAboutPressed:(id)sender {

    [self.detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (IBAction)onLocationPressed:(id)sender {

    [self.detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}

- (IBAction)onSpecialsPressed:(id)sender {

    [self.detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}
- (IBAction)onHoursPressed:(id)sender {

    [self.detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}

@end
