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

@interface TravelTimeViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *fiveMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *tenMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *twentyMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *thirtyMinuteButton;
@property (assign, nonatomic) NSInteger selectedTime;

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation TravelTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *buttons = @[self.fiveMinuteButton, self.tenMinuteButton, self.twentyMinuteButton, self.thirtyMinuteButton];
    for (UIButton *button in buttons)
    {
        [self formatTimeButton:button];
    }
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self startLocationService];
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

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)formatTimeButton:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (IBAction)timeButtonTapped:(id)sender {
    UIButton *button = sender;
    self.selectedTime = button.tag;
    [self performSegueWithIdentifier:@"goToPreference" sender:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = (CLLocation *)locations[0];
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FilterViewController *destVC = segue.destinationViewController;
    NSInteger timeInMinute = self.selectedTime;
    destVC.timeInMinute = timeInMinute;
    destVC.currentLatitude = self.currentLocation.coordinate.latitude;
    destVC.currentLongitude = self.currentLocation.coordinate.longitude;
}


@end
