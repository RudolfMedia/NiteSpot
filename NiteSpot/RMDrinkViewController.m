//
//  RMDrinkViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMDrinkViewController.h"
#import "SpotCell.h"
#import "RMEatViewController.h"
#import "Spot.h"

@interface RMDrinkViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *drinkCollectionView;

@end

@implementation RMDrinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.drinkSpotsArray);


}

#pragma mark - CollectionView Datsource / Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.drinkSpotsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SpotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Spot *spot = [self.drinkSpotsArray objectAtIndex:indexPath.row];
    cell.drinkCellTitle.text = spot.spotTitle;
    cell.drinkCellImage.image = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:spot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *cellImage = [UIImage imageWithData:data];
            cell.drinkCellImage.image = cellImage;
        });
    }];

    return cell;
}






@end
