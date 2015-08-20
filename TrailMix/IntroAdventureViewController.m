//
//  IntroAdventureViewController.m
//  TrailMix
//
//  Created by Mason Macias on 8/12/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//
@import TrailMixFramework;

#import "IntroAdventureViewController.h"
#import "NaviViewController.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"
#import "DataStore.h"
#import <CoreLocation/CoreLocation.h>

@interface IntroAdventureViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *adventureButtons;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@end

@implementation IntroAdventureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    if([CLLocationManager locationServicesEnabled]){
        
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
                [locationManager requestAlwaysAuthorization];
        }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            //ask user to enable location permission on settings
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Service Disabled" message:@"Please Enable Location Service to Make App Work" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"Location" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alertController addAction:goToSettingsAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }else{
            //no idea what will happed
        }
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Service Disabled" message:@"Please Enable Location Service to Make App Work" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *goToSettingsAction = [UIAlertAction actionWithTitle:@"Location" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy&path=LOCATION"]];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:goToSettingsAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![RestaurantCDObject getLatestRestaurant]){
        self.resumeButton.enabled = NO;
        [self.resumeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.resumeButton.layer.borderColor = [UIColor grayColor].CGColor;
    }else{
        self.resumeButton.enabled = YES;
        [self.resumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.resumeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (IBAction)resumeButtonTapped:(id)sender {
    UIViewController *destVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    [DataStore sharedDataStore].destinationIsResaurant = YES;
    [self presentViewController:destVC animated:YES completion:nil];
}

@end
