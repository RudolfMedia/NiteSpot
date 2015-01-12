//
//  SpotCell.h
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *spotImage;
@property (weak, nonatomic) IBOutlet UIImageView *drinkCellImage;
@property (weak, nonatomic) IBOutlet UILabel *drinkCellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *attendImageView;
@property (weak, nonatomic) IBOutlet UILabel *attendCellTitle;

@end
