//
//  RMSpotDetailView.h
//  NiteSpot
//
//  Created by Dan Rudolf on 1/20/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUImage/GPUImage.h>
#import <AFScrollView/AFScrollView.h>

#import "Spot.h"

@interface RMSpotDetailView : UIViewController

@property Spot *selectedSpot;
@property (weak, nonatomic) IBOutlet UIImageView *detailTypeImage;


@end
