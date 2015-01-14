//
//  drinkCellCollectionViewCell.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/13/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "DrinkCell.h"

@implementation DrinkCell
- (void)setupImageView
{
    // Clip subviews
    self.clipsToBounds = YES;

    // Add image subview
    self.drinkCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.drinkCellImageView.backgroundColor = [UIColor redColor];
    self.drinkCellImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.drinkCellImageView.clipsToBounds = NO;
    [self addSubview:self.drinkCellImageView];
}

- (void)setImage:(UIImage *)image
{
    // Store image
    self.drinkCellImageView.image = image;

    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;

    // Grow image view
    CGRect frame = self.drinkCellImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.drinkCellImageView.frame = offsetFrame;
}

@end
