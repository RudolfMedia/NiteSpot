//
//  RMSpotDetailContent.m
//  NiteSpot
//
//  Created by Dan Rudolf on 3/20/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMSpotDetailContent.h"

@implementation RMSpotDetailContent

- (IBAction)onMonPressed:(id)sender {
}

+ (id)spotDetailContent{

    RMSpotDetailContent *detailContent = [[[NSBundle mainBundle] loadNibNamed:@"RMSpotDetailContent"
                                                                        owner:nil options:nil] lastObject];
    if ([detailContent isKindOfClass:[RMSpotDetailContent class]]) {
        return detailContent;
    }
    else{
        return nil;
    }
}


@end
