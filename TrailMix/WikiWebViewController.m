//
//  WikiWebViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 8/3/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiWebViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface WikiWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WikiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    
    
    [self.webView loadRequest:request];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

@end
