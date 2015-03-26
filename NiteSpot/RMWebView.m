//
//  RMWebView.m
//  NiteSpot
//
//  Created by Dan Rudolf on 3/26/15.
//  Copyright (c) 2015 com.rudolfmedia. All rights reserved.
//

#import "RMWebView.h"

@interface RMWebView ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RMWebView

- (void)viewDidLoad {
    [super viewDidLoad];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.menu]];

    [self.webView loadRequest:request];
}



@end
