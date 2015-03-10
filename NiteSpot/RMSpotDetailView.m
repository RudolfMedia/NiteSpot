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

@interface RMSpotDetailView () <UICollectionViewDataSource, UIBarPositioningDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, RMMapViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *detailPhoto;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailinfoString;
@property (weak, nonatomic) IBOutlet UILabel *detailPricePhone;
@property (weak, nonatomic) IBOutlet UIButton *detailAbout;
@property (weak, nonatomic) IBOutlet UIButton *detailSpecials;

@property (weak, nonatomic) IBOutlet UICollectionView *detailCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *detailLocation;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLable;

@property CLLocationCoordinate2D *currentLocation;
@property CLLocationManager *locationManager;
@property UICollectionViewFlowLayout *flowLayout;


@end

@implementation RMSpotDetailView

- (void)viewDidLoad {

    [super viewDidLoad];
    [self geoCodeCurrentSpot];

    self.detailCollectionView.delegate = self;

    NSLog(@"%@", self.selectedSpot.type);

    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self formatButton:self.detailAbout];
    [self formatButton:self.detailLocation];
    [self formatButton:self.detailSpecials];

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

    [self.detailCollectionView registerNib:[UINib nibWithNibName:@"AboutCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"AboutCell"];

        [self.detailCollectionView registerClass:[LocationCell class] forCellWithReuseIdentifier:@"LocationCell"];
}

#pragma mark - UICollectionview Datasource / Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGSize cellSize = CGSizeMake(self.detailCollectionView.frame.size.width,
                                 self.detailCollectionView.frame.size.height);
    return cellSize;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 2;

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

    }

    else if (indexPath == [NSIndexPath indexPathForItem:3 inSection:0]){

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

    [self.detailTitleLable setText:@"About"];

    [self.detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (IBAction)onLocationPressed:(id)sender {

    [self.detailTitleLable setText:@"Location"];

    [self.detailCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

}


@end
