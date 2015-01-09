//
//  ViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/5/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMEatViewController.h"
#import "Spot.h"
#import "SpotCell.h"

@interface RMEatViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *eatCollectionView;

@end

@implementation RMEatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eatSpotsArray = [NSMutableArray new];
    self.drinkSpotsArray = [NSMutableArray new];
    self.attendSpotsArray = [NSMutableArray new];
    [self downloadSpots];


}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SpotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Spot *spot = [self.eatSpotsArray objectAtIndex:indexPath.row];
    cell.cellTitle.text = spot.spotTitle;
    cell.spotImage.image = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:spot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *cellImage = [UIImage imageWithData:data];
            cell.spotImage.image = cellImage;
        });
    }];

    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.eatSpotsArray.count;
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
            
            NSLog(@"%@ %@ %@",self.eatSpotsArray, self.drinkSpotsArray, self.attendSpotsArray);

        });
    });


}


@end
