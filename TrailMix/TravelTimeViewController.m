//
//  TravelTimeViewController.m
//  TrailMix
//
//  Created by Mason Macias on 8/5/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "TravelTimeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FilterViewController.h"
#import "IntroAdventureViewController.h"
#import <SVProgressHUD.h>
#import "FourSquareAPIClient.h"
#import <FAKFontAwesome.h>

@interface TravelTimeViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *fiveMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *tenMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *twentyMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *thirtyMinuteButton;
@property (assign, nonatomic) NSInteger selectedTime;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation TravelTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackButton];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self startLocationService];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLocationService{
    if([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
                [self.locationManager requestAlwaysAuthorization];
            }
            [self.locationManager startUpdatingLocation];
            [self.locationManager startUpdatingHeading];
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            //ask user to enable location permission on settings
            
        }else{
            [self.locationManager startUpdatingLocation];
            [self.locationManager startUpdatingHeading];
        }
    }else{
        //give warning to enable the location service
    }
    
}

-(void)setupBackButton
{
    FAKFontAwesome *backIcon = [FAKFontAwesome angleLeftIconWithSize:40];
    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.backButton setAttributedTitle:[backIcon attributedString] forState:UIControlStateNormal];
    
}

- (void)badNetworkRequest:(NSNotification *)notification
{
    [SVProgressHUD showErrorWithStatus:@"Not able to connect, please try again"];
    
}

-(void)notifyIfBadRequest
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badNetworkRequest:) name:@"BadRequest" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)timeButtonTapped:(id)sender {
    [self notifyIfBadRequest];
    UIButton *button = sender;
    self.selectedTime = button.tag;
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [FourSquareAPIClient getNearbyRestaurantWithLatitude:self.currentLocation.coordinate.latitude Longitude:self.currentLocation.coordinate.longitude Radius:self.selectedTime*83.1495 CompletionBlock:^() {
        [SVProgressHUD dismiss];
        [self performSegueWithIdentifier:@"goToPreference" sender:nil];
    }];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = (CLLocation *)locations[0];
}



#pragma mark - Navigation

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
