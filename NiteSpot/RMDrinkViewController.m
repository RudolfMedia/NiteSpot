//
//  RMDrinkViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMDrinkViewController.h"
#import "DrinkCell.h"
#import "RMEatViewController.h"
#import "Spot.h"
#import "UIViewController+ScrollingNavbar.h"

@interface RMDrinkViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *drinkCollectionView;


@end

@implementation RMDrinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self followScrollView:self.drinkCollectionView];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAttendCollectionView:)
                                                 name:@"DownloadDone"
                                               object:nil];

}

- (void)showAttendCollectionView:(NSNotification *)notification {

    [self.drinkCollectionView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.drinkCollectionView.alpha = 0;

    [UIView transitionWithView:self.drinkCollectionView
                      duration:0.40f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        self.drinkCollectionView.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];
    

}

#pragma mark - CollectionView Datsource / Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataLoader.drinkSpotsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DrinkCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Spot *spot = [self.dataLoader.drinkSpotsArray objectAtIndex:indexPath.row];

    cell.drinkCellTitle.layer.masksToBounds = YES;
    cell.drinkCellTitle.layer.cornerRadius = 3;
    cell.drinkCellTitle.text = spot.spotTitle;

    cell.addressLabel.layer.masksToBounds = YES;
    cell.addressLabel.layer.cornerRadius = 3;
    cell.addressLabel.text = spot.spotStreet;

    cell.priceLabel.layer.masksToBounds = YES;
    cell.priceLabel.layer.cornerRadius = 20;
    cell.priceLabel.text = spot.price;

    cell.drinkCellImageView.image = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:spot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *cellImage = [UIImage imageWithData:data];
            cell.drinkCellImageView.image = cellImage;
        });
    }];

    CGFloat yOffset = ((self.drinkCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);

    cell.alpha = 0.0f;

    [UIView transitionWithView:cell.contentView
                      duration:0.30f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        cell.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];

    return cell;
}

#pragma mark - ScrollView Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(DrinkCell *view in self.drinkCollectionView.visibleCells) {
        CGFloat yOffset = ((self.drinkCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}







@end
