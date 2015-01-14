//
//  attendCell.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/13/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "AttendCell.h"

@implementation AttendCell
- (void)setupImageView
{
    // Clip subviews
    self.clipsToBounds = YES;

    // Add image subview
    self.attendCellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, IMAGE_HEIGHT)];
    self.attendCellImageView.backgroundColor = [UIColor redColor];
    self.attendCellImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.attendCellImageView.clipsToBounds = NO;
    [self addSubview:self.attendCellImageView];
}

- (void)setImage:(UIImage *)image
{
    // Store image
    self.attendCellImageView.image = image;

    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;

    // Grow image view
    CGRect frame = self.attendCellImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.attendCellImageView.frame = offsetFrame;
}
@end
