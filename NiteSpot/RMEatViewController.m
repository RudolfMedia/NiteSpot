//
//  ViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMEatViewController.h"
#import "RMDrinkViewController.h"
#import "RMAttendViewController.h"
#import "RMMapSearchViewController.h"
#import "Spot.h"
#import "EatCell.h"

#define API_KEY 5


@interface RMEatViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *eatCollectionView;

@end

@implementation RMEatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eatSpotsArray = [NSMutableArray new];
    self.drinkSpotsArray = [NSMutableArray new];
    self.attendSpotsArray = [NSMutableArray new];
    self.view.backgroundColor = [UIColor blackColor];
    self.apiKey = @"Fmjtd%7Cluu829u8n5%2Cb2%3Do5-9w1wdy";

    [self setUpTabBar];

    self.tabBarController.delegate = self;

    [self downloadSpots];


}

-(void)viewWillAppear:(BOOL)animated{
    self.eatCollectionView.alpha = 0;

    [UIView transitionWithView:self.eatCollectionView
                      duration:0.40f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        self.eatCollectionView.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];
    
    
}

#pragma mark - TabBar Delegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    if ([viewController.childViewControllers.firstObject isKindOfClass:[RMDrinkViewController class]]) {
        RMDrinkViewController *destination = (RMDrinkViewController *)viewController.childViewControllers.firstObject;
        destination.drinkSpotsArray = self.drinkSpotsArray;

    }
    
    else if ([viewController.childViewControllers.firstObject isKindOfClass:[RMAttendViewController class]]){

        RMAttendViewController *destination = (RMAttendViewController *)viewController.childViewControllers.firstObject;
        destination.attendSpotsArray = self.attendSpotsArray;
    }

    else if ([viewController.childViewControllers.firstObject isKindOfClass:[RMMapSearchViewController class]]){

        RMMapSearchViewController *destination = (RMMapSearchViewController *)viewController.childViewControllers.firstObject;
        destination.eatSpotsArray = self.eatSpotsArray;
        destination.drinkSpotsArray = self.drinkSpotsArray;
        destination.attendSpotsArray = self.attendSpotsArray;
    }

    return TRUE;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}

#pragma mark - CollectionvView Datasource / Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    EatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Spot *spot = [self.eatSpotsArray objectAtIndex:indexPath.row];
    cell.eatCellTitle.layer.masksToBounds = YES;
    cell.eatCellTitle.layer.cornerRadius = 3;
    cell.eatCellTitle.text = [NSString stringWithFormat:@" %@",spot.spotTitle];
    cell.eatCellImage.image = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:spot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *cellImage = [UIImage imageWithData:data];
            cell.eatCellImage.image = cellImage;
        });
    }];

    cell.alpha = 0.0f;

    [UIView transitionWithView:cell.contentView
                      duration:0.30f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        cell.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];
    CGFloat yOffset = ((self.eatCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);

    
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.eatSpotsArray.count;
}


#pragma mark - ScrollView Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(EatCell *view in self.eatCollectionView.visibleCells) {
        CGFloat yOffset = ((self.eatCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

#pragma Mark - Networking and Parsing methods

- (void)downloadSpots{

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://thenitespot.com/active_index.php"]];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        self.spotJSONArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

        [self parseSpotObjects];

    }];

}

- (void)parseSpotObjects{

    dispatch_queue_t spotQueue = dispatch_queue_create("SpotQueue", NULL);
    dispatch_async(spotQueue, ^{

        for (NSDictionary *dictionary  in self.spotJSONArray) {
            Spot *spot = [[Spot alloc] initWithName:[dictionary objectForKey:@"title"]
                                               type:[dictionary objectForKey:@"type"]
                                               idNo:[dictionary objectForKey:@"id"]
                                             region:[dictionary objectForKey:@"region"]
                                               city:[dictionary objectForKey:@"city"]
                                             street:[dictionary objectForKey:@"street"]
                                              state:[dictionary objectForKey:@"state"]
                                                zip:[dictionary objectForKey:@"zip"]
                                              about:[dictionary objectForKey:@"about"]
                                                tel:[dictionary objectForKey:@"tel"]
                                           foodType:[dictionary objectForKey:@"eat"]
                                          drinkType:[dictionary objectForKey:@"drink"]
                                              price:[dictionary objectForKey:@"price"]
                                       dailySpecial:[dictionary objectForKey:@"general"]
                                            foodMon:[dictionary objectForKey:@"eat_Mon"]
                                            foodTue:[dictionary objectForKey:@"eat_Tue"]
                                            foodWed:[dictionary objectForKey:@"eat_Wed"]
                                            foodThu:[dictionary objectForKey:@"eat_Thu"]
                                            foodFri:[dictionary objectForKey:@"eat_Fri"]
                                            foodSat:[dictionary objectForKey:@"eat_sat"]
                                            foodSun:[dictionary objectForKey:@"eat_Sun"]
                                           drinkMon:[dictionary objectForKey:@"drink_Mon"]
                                           drinkTue:[dictionary objectForKey:@"drink_Tue"]
                                           drinkWed:[dictionary objectForKey:@"drink_Wed"]
                                           drinkThu:[dictionary objectForKey:@"drink_Thu"]
                                           drinkFri:[dictionary objectForKey:@"drink_Fri"]
                                           drinkSat:[dictionary objectForKey:@"drink_Sat"]
                                           drinkSun:[dictionary objectForKey:@"drink_Sun"]
                                               slug:[dictionary objectForKey:@"slug"]
                                              thumb:[dictionary objectForKey:@"thumb"]];
            NSString *slug = spot.slug;
            slug = [slug stringByReplacingOccurrencesOfString:@" " withString:@"%20"];


            NSString *urlString = [NSString stringWithFormat:@"http://www.thenitespot.com/images/spots/%@/%@",slug,spot.thumb];
            [spot addThumbURL:[NSURL URLWithString:urlString]];

            NSString *streetNoSpace = [spot.spotStreet stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

            NSURL *geoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.mapquestapi.com/geocoding/v1/address?key=%@&street=%@&city=Pittsburgh&state=PA&postalCode=%@thumbMaps=false&maxResults=1",self.apiKey, streetNoSpace, spot.spotZip]];
            NSURLRequest *geoReques = [[NSURLRequest alloc] initWithURL:geoURL];

            [NSURLConnection sendAsynchronousRequest:geoReques queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                NSDictionary *jsonDictionay = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

                spot.lat = [[jsonDictionay valueForKeyPath:@"results.locations.latLng.lat"] firstObject];
                spot.lon = [[jsonDictionay valueForKeyPath:@"results.locations.latLng.lng"] firstObject];



            }];



            if ([spot.type isEqualToString:@"a"] || [spot.type isEqualToString:@"c"]) {

                [self.eatSpotsArray addObject:spot];
            }

            else if ([spot.type isEqualToString:@"b"]){
                [self.drinkSpotsArray addObject:spot];
            }

            else if ([spot.type isEqualToString:@"d"]){
                [self.attendSpotsArray addObject:spot];
            }


        }


        dispatch_async(dispatch_get_main_queue(), ^{

            [self.eatCollectionView reloadData];

            NSUInteger countEat = [self.eatSpotsArray count];
            for (NSUInteger i = 0; i < countEat; ++i) {
                NSUInteger nElements = countEat - i;
                NSUInteger n = (arc4random() % nElements) + i;
             [self.eatSpotsArray exchangeObjectAtIndex:i withObjectAtIndex:n];
            }

            NSUInteger countDrink = [self.drinkSpotsArray count];
            for (NSUInteger i = 0; i < countDrink; ++i) {
                NSUInteger nElements = countDrink - i;
                NSUInteger n = (arc4random() % nElements) + i;
                [self.eatSpotsArray exchangeObjectAtIndex:i withObjectAtIndex:n];
            }

            NSUInteger countAttend = [self.eatSpotsArray count];
            for (NSUInteger i = 0; i < countAttend; ++i) {
                NSUInteger nElements = countAttend - i;
                NSUInteger n = (arc4random() % nElements) + i;
                [self.eatSpotsArray exchangeObjectAtIndex:i withObjectAtIndex:n];
            }

        });
    });


}


- (void)setUpTabBar{

    UITabBar *customTabBar = self.tabBarController.tabBar;
    customTabBar.tintColor = [UIColor clearColor];
    customTabBar.backgroundColor = [UIColor clearColor];

    UITabBarItem *eatTab = [customTabBar.items objectAtIndex:0];
    eatTab.image = [[UIImage imageNamed:@"eat6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    eatTab.selectedImage = [[UIImage imageNamed:@"eatPressed6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    eatTab.title = nil;

    UITabBarItem *drinkTab = [customTabBar.items objectAtIndex:1];
    drinkTab.image = [[UIImage imageNamed:@"drink6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    drinkTab.selectedImage = [[UIImage imageNamed:@"drinkPressed6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    drinkTab.title = nil;

    UITabBarItem *attendTab = [customTabBar.items objectAtIndex:2];
    attendTab.image = [[UIImage imageNamed:@"attend6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    attendTab.selectedImage = [[UIImage imageNamed:@"attendPressed6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    attendTab.title = nil;

    UITabBarItem *mapTab = [customTabBar.items objectAtIndex:3];
    mapTab.image = [[UIImage imageNamed:@"map6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mapTab.selectedImage = [[UIImage imageNamed:@"mapPressed6"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mapTab.title = nil;


}












@end
