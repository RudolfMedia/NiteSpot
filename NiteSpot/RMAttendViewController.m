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

@property (weak, nonatomic) IBOutlet UICollectionView *attendCollectionView;

@end

@implementation RMAttendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];


    NSLog(@"%@",self.attendSpotsArray);
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
    cell.alpha = 0.0f;

    [UIView transitionWithView:cell.contentView
                      duration:0.35f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{

                        cell.alpha = 1.0f;

                    } completion:^(BOOL finished) {
                    }];
    


    return cell;



}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.attendSpotsArray.count;
}
@end
