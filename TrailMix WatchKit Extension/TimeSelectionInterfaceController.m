//
//  TimeSelectionInterfaceController.m
//  TrailMix
//
//  Created by Cong Sun on 8/12/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "TimeSelectionInterfaceController.h"


@interface TimeSelectionInterfaceController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;


@end

@implementation TimeSelectionInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if(self.locationManager == nil){
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedAlways)
    {
        NSLog(@"%@ Start tracking current location", self);
        
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        // provide some error
    }
    
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = (CLLocation *)locations[0];
}


@end



