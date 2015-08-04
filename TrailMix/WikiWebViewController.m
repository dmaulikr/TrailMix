//
//  WikiWebViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 8/3/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiWebViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataStore.h"

@interface WikiWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation WikiWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataStore = [DataStore sharedDataStore];
    
    UIBarButtonItem *routeButton = [[UIBarButtonItem alloc] initWithTitle:@"Route" style:UIBarButtonItemStylePlain target:self action:@selector(setHeadingToWikiLocation)];
    
    self.navigationItem.rightBarButtonItem = routeButton;
    
    NSString *urlString = [NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@", [self.wikiArticle.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.webView.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void) setHeadingToWikiLocation {
 
    self.dataStore.pointOfInterest = self.wikiArticle;
    
    [SVProgressHUD dismiss];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
