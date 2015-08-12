//
//  RestaurantDestinationWebViewController.m
//  TrailMix
//
//  Created by Henry Chan on 8/11/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "RestaurantDestinationWebViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface RestaurantDestinationWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RestaurantDestinationWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    [self.webView loadRequest:request];
    
}
- (IBAction)dismissButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}


@end
