//
//  RMAttendViewController.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMAttendViewController.h"
#import "SpotCell.h"
#import "Spot.h"

@interface RMAttendViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation RMAttendViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSLog(@"%@",self.attendSpotsArray);
}


#pragma mark - CollectionView DataSource / Delegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    SpotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Spot *spot = [self.attendSpotsArray objectAtIndex:indexPath.row];
    cell.attendCellTitle.text = spot.spotTitle;
    cell.attendImageView.image = nil;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:spot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *cellImage = [UIImage imageWithData:data];
            cell.attendImageView.image = cellImage;
        });
    }];

    return cell;



}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.attendSpotsArray.count;
}
@end
