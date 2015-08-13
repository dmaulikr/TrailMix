//
//  WKNaviInterfaceController.m
//  TrailMix
//
//  Created by Cong Sun on 8/12/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "WKNaviInterfaceController.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"
#import "DataStore.h"

@interface WKNaviInterfaceController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *distanceLabel;
@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLLocation *destinationLocation;
@property (strong, nonatomic)CLLocation *currentLocation;
@property (assign, nonatomic)CGFloat remainingDistance;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *helperLabel;
@property (strong, nonatomic) RestaurantCDObject *restaurant;
@end

@implementation WKNaviInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
//    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    
    //change when select other transporation type
    self.locationManager.activityType = CLActivityTypeFitness;
    
    
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)
    {
        NSLog(@"%@ Start tracking current location", self);
        
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        // provide some error
    }
    
    
    self.restaurant = [RestaurantCDObject getLatestRestaurant];
    [self.helperLabel setText:self.restaurant.name];
    self.destinationLocation = [[CLLocation alloc]initWithLatitude:self.restaurant.latitude.floatValue longitude:self.restaurant.longitude.floatValue];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = locations[0];
    self.remainingDistance = [self.currentLocation distanceFromLocation:self.destinationLocation];
    [self.distanceLabel setText:[NSString stringWithFormat:@"%.2f m",self.remainingDistance]];
}

- (IBAction)cancelTripButtonTapped {
    //delete that from coredata
    
    [[DataStore sharedDataStore].managedObjectContext deleteObject:self.restaurant];
    
    [self popToRootController];
}

- (IBAction)pauseTripBUttonTapped {
    [self popToRootController];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}



- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



