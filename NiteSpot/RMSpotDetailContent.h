//
//  RMSpotDetailContent.h
//  NiteSpot
//
//  Created by Dan Rudolf on 3/20/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMSpotDetailContent : UIView

@property (weak, nonatomic) IBOutlet UIImageView *detailPhoto;
@property (weak, nonatomic) IBOutlet UILabel *detailInfoString;
@property (weak, nonatomic) IBOutlet UILabel *detailPricePhone;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageThree;
@property (weak, nonatomic) IBOutlet UILabel *detailOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailThreeLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *xibView;


+(id)spotDetailContent;

@end
