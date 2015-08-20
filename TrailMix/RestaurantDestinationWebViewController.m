//
//  RestaurantDestinationWebViewController.m
//  TrailMix
//
//  Created by Henry Chan on 8/11/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "RestaurantDestinationWebViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <FAKFontAwesome.h>

@interface RestaurantDestinationWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation RestaurantDestinationWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    FAKFontAwesome *backIcon = [FAKFontAwesome angleLeftIconWithSize:40];
    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.backButton setAttributedTitle:[backIcon attributedString] forState:UIControlStateNormal];
    
    self.locationLabel.text = self.locationName;
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    
    [self.webView loadRequest:request];
    
}
- (IBAction)dismissButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


@end
