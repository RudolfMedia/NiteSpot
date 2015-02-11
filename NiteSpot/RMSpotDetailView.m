//
//  RMSpotDetailView.m
//  NiteSpot
//
//  Created by Dan Rudolf on 1/20/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMSpotDetailView.h"

@interface RMSpotDetailView ()

@property (weak, nonatomic) IBOutlet UIImageView *detailPhoto;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailinfoString;
@property (weak, nonatomic) IBOutlet UILabel *detailPriceTime;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation RMSpotDetailView

- (void)viewDidLoad {
    [super viewDidLoad];

    self.aboutTextView.scrollEnabled = NO;

    self.detailPhoto.backgroundColor = [UIColor blackColor];

    self.detailTypeImage.image = [UIImage imageNamed:@"detailEat"];

    self.detailTitle.text = self.selectedSpot.spotTitle;

    self.detailinfoString.text = [NSString stringWithFormat:@"%@ \u2022 %@",
                                  self.selectedSpot.foodType,
                                  self.selectedSpot.drinkType];

    self.detailPriceTime.text = [NSString stringWithFormat:@"%@ \u2022 %@",
                                  self.selectedSpot.price,
                                  self.selectedSpot.spotTel];

    [self.aboutTextView setText:self.selectedSpot.spotAbout];
    self.aboutTextView.scrollEnabled = YES;


    GPUImageiOSBlurFilter *iosBlur = [[GPUImageiOSBlurFilter alloc] init];
//    GPUImagePixellateFilter *filter = [[GPUImagePixellateFilter alloc] init];
//    filter.fractionalWidthOfAPixel = 0.04;
    iosBlur.blurRadiusInPixels = 1;
    

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.selectedSpot.thumbURL];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        UIImage *image = [UIImage imageWithData:data];
        self.detailPhoto.image = [iosBlur imageByFilteringImage:image];

    }];
}



@end
