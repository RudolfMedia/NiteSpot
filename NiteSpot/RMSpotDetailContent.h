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
@property (weak, nonatomic) IBOutlet UIView *imageContainer;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;
@property (weak, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UIView *specialsContainerView;
@property (weak, nonatomic) IBOutlet UIView *specialsInnerContainer;
@property (weak, nonatomic) IBOutlet UIButton *monSpecialButton;
@property (weak, nonatomic) IBOutlet UIButton *tueSpecialButton;
@property (weak, nonatomic) IBOutlet UIButton *wedSpecialButton;
@property (weak, nonatomic) IBOutlet UIButton *thuSpecialButton;
@property (weak, nonatomic) IBOutlet UIButton *friSpecialButton;
@property (weak, nonatomic) IBOutlet UIButton *satSpecialButton;
@property (weak, nonatomic) IBOutlet UIButton *sunSpecialButton;
@property (weak, nonatomic) IBOutlet UITextView *eatSpecial;
@property (weak, nonatomic) IBOutlet UITextView *drinkSpecial;
@property (weak, nonatomic) IBOutlet UIButton *callPressed;
@property (weak, nonatomic) IBOutlet UIImageView *eatSpecialImage;
@property (weak, nonatomic) IBOutlet UIImageView *drinkSpecialImage;
@property (weak, nonatomic) IBOutlet UILabel *noFoodIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noDrinkIndicator;
@property (weak, nonatomic) IBOutlet UIView *locationContainer;
@property (weak, nonatomic) IBOutlet UIView *locationMapContainer;

+(id)spotDetailContent;

@end
