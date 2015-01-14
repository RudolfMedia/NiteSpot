//
//  SpotCell.h
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_HEIGHT 266
#define IMAGE_OFFSET_SPEED 12

@interface EatCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *eatCellTitle;
@property (strong, nonatomic) IBOutlet UIImageView *eatCellImage;
@property (nonatomic, assign, readwrite) CGPoint imageOffset;



@end
