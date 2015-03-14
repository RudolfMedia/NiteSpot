//
//  RMAttendViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMAttendViewController.h"
#import "AttendCell.h"
#import "Spot.h"
#import "UIViewController+ScrollingNavbar.h"
#import "RMVenueLocationDetail.h"


@interface RMAttendViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *attendCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;

@end

@implementation RMAttendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUseSuperview:NO];

    self.view.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self followScrollView:self.attendCollectionView];
    [self followScrollView:self.attendCollectionView usingTopConstraint:self.topLayoutConstraint];



    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadAttendView:)
                                                 name:@"DownloadDone"
                                               object:nil];

}

- (void)reloadAttendView:(NSNotification *)notification{

    [self.attendCollectionView reloadData];

}



-(void)viewWillAppear:(BOOL)animated{
    self.attendCollectionView.alpha = 0;

    [UIView transitionWithView:self.attendCollectionView
                      duration:0.40f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        //any animatable attribute here.
                        self.attendCollectionView.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];
    
    
}



#pragma mark - CollectionView DataSource / Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    AttendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    Spot *spot = [self.dataLoader.attendSpotsArray objectAtIndex:indexPath.row];

    cell.attendCellTitle.layer.masksToBounds = YES;
    cell.attendCellTitle.layer.cornerRadius = 3;
    cell.attendCellTitle.text = spot.spotTitle;

    cell.addressLabel.layer.masksToBounds = YES;
    cell.addressLabel.layer.cornerRadius = 3;
    cell.addressLabel.text = spot.spotStreet;

    cell.priceLabel.layer.masksToBounds = YES;
    cell.priceLabel.layer.cornerRadius = 20;
    cell.priceLabel.text = spot.price;

    cell.attendCellImageView.image = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:spot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *cellImage = [UIImage imageWithData:data];
            cell.attendCellImageView.image = cellImage;
        });
    }];
    cell.alpha = 0.0f;
    
    CGFloat yOffset = ((self.attendCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);


    [UIView transitionWithView:cell.contentView
                      duration:0.3f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        cell.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];

    return cell;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.dataLoader.attendSpotsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{


    CGSize sizeForCell = CGSizeMake(collectionView.frame.size.width, 280);

    return sizeForCell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSIndexPath *selectedIndex = self.attendCollectionView.indexPathsForSelectedItems.firstObject;
    Spot *selectedSpot = [self.dataLoader.attendSpotsArray objectAtIndex:selectedIndex.item];
    RMVenueLocationDetail *destination = [segue destinationViewController];
    destination.selectedSpot = selectedSpot;
    
}

#pragma mark - ScrollView Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(AttendCell *view in self.attendCollectionView.visibleCells) {
        CGFloat yOffset = ((self.attendCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}

@end
