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
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *specialsButton;
@property (weak, nonatomic) IBOutlet UIButton *hoursButton;
@property (weak, nonatomic) IBOutlet UIView *container;

@end

@implementation RMSpotDetailView

- (void)viewDidLoad {

    [super viewDidLoad];

    AFScrollView *scrollView = [[AFScrollView alloc] initWithFrame:self.container.bounds andNumberOfPages:5];
    [self.container addSubview:scrollView];
    [scrollView configureViewAtIndexWithCompletion:^(UIView *view, NSInteger index, BOOL success) {

        if (index == 0) {
            view.backgroundColor = [UIColor redColor];
        }

        else if (index == 1)
            view.backgroundColor = [UIColor greenColor];
    }];

    [self formatButton:self.aboutButton];
    [self.aboutButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self formatButton:self.locationButton];
    [self formatButton:self.specialsButton];
    [self formatButton:self.hoursButton];

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

-(UIButton *)formatButton:(UIButton *)button{

    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 8;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    return button;
}




@end
