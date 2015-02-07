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
#import "UIViewController+ScrollingNavbar.h"
#import "RMSpotDetailView.h"
#import "DataLoader.h"

@interface RMEatViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITabBarControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *eatCollectionView;
@property DataLoader *dataLoader;

@end

@implementation RMEatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpTabBar];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self followScrollView:self.eatCollectionView];

    self.eatCollectionView.delegate = self;

    self.tabBarController.delegate = self;

    self.dataLoader = [[DataLoader alloc] init];
    [self.dataLoader downloadSpots];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showEatCollectionView:)
                                                 name:@"DownloadDone"
                                               object:nil];

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

- (void)showEatCollectionView:(NSNotification *)notification {

    [self.eatCollectionView reloadData];

}

#pragma mark - TabBar Delegate
//
//-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//
//    if ([viewController.childViewControllers.firstObject isKindOfClass:[RMDrinkViewController class]]) {
//        RMDrinkViewController *destination = (RMDrinkViewController *)viewController.childViewControllers.firstObject;
//        destination.drinkSpotsArray = self.drinkSpotsArray;
//
//    }
//    
//    else if ([viewController.childViewControllers.firstObject isKindOfClass:[RMAttendViewController class]]){
//
//        RMAttendViewController *destination = (RMAttendViewController *)viewController.childViewControllers.firstObject;
//        destination.attendSpotsArray = self.attendSpotsArray;
//    }
//
//    else if ([viewController.childViewControllers.firstObject isKindOfClass:[RMMapSearchViewController class]]){
//
//        RMMapSearchViewController *destination = (RMMapSearchViewController *)viewController.childViewControllers.firstObject;
//        destination.eatSpotsArray = self.eatSpotsArray;
//        destination.drinkSpotsArray = self.drinkSpotsArray;
//        destination.attendSpotsArray = self.attendSpotsArray;
//    }
//
//    return TRUE;
//
//}



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


#pragma mark - CollectionView Delegate / Datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    EatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Spot *spot = [self.dataLoader.eatSpotsArray objectAtIndex:indexPath.row];

    cell.eatCellTitle.layer.masksToBounds = YES;
    cell.eatCellTitle.layer.cornerRadius = 3;
    cell.eatCellTitle.text = spot.spotTitle;

    cell.eatCellAddress.layer.masksToBounds = YES;
    cell.eatCellAddress.layer.cornerRadius = 3;
    cell.eatCellAddress.text = spot.spotStreet;

    cell.pricelabel.layer.masksToBounds = YES;
    cell.pricelabel.layer.cornerRadius = 20;
    cell.pricelabel.text = spot.price;
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

    return self.dataLoader.eatSpotsArray.count;

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSIndexPath *selectedIndex = self.eatCollectionView.indexPathsForSelectedItems.firstObject;
    Spot *selectedSpot = [self.dataLoader.eatSpotsArray objectAtIndex:selectedIndex.item];
    RMSpotDetailView *destination = [segue destinationViewController];
    destination.selectedSpot = selectedSpot;

    NSLog(@"%@", selectedSpot.spotTitle);

}


#pragma mark - ScrollView Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(EatCell *view in self.eatCollectionView.visibleCells) {
        CGFloat yOffset = ((self.eatCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}


@end
