//
//  SpotCell.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/7/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "EatCell.h"

@implementation EatCell

- (void)setupImageView
{
    // Clip subviews
    self.clipsToBounds = YES;

    // Add image subview
    self.eatCellImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.eatCellImage.backgroundColor = [UIColor redColor];
    self.eatCellImage.contentMode = UIViewContentModeScaleAspectFill;
    self.eatCellImage.clipsToBounds = NO;
    [self addSubview:self.eatCellImage];
}

- (void)setImage:(UIImage *)image
{
    // Store image
    self.eatCellImage.image = image;

    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;

    // Grow image view
    CGRect frame = self.eatCellImage.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.eatCellImage.frame = offsetFrame;
}

@end
