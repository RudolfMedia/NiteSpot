//
//  attendCell.h
//  NiteSpot
//
//  Created by Dan Rudolf on 1/13/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_HEIGHT 266
#define IMAGE_OFFSET_SPEED 12

@interface AttendCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *attendCellImageView;
@property (weak, nonatomic) IBOutlet UILabel *attendCellTitle;
@property (nonatomic, assign, readwrite) CGPoint imageOffset;


@end
