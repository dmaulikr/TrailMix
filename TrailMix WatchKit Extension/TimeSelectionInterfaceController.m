//
//  TimeSelectionInterfaceController.m
//  TrailMix
//
//  Created by Cong Sun on 8/12/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "TimeSelectionInterfaceController.h"
#import "TrailMixFramework.h"

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
//        self.locationManager.pausesLocationUpdatesAutomatically = YES;
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

- (IBAction)fiveMinuteButtonTapped {
    
    [FourSquareAPIClient getRandomNearbyRestaurantWithLatitude:self.currentLocation.coordinate.latitude Longitude:self.currentLocation.coordinate.longitude Radius:5*83.1495 CompletionBlock:^{
        [self pushControllerWithName:@"WKNaviInterfaceController" context:nil];
    }];
}

- (IBAction)tenMinuteButtonTapped {
    [FourSquareAPIClient getRandomNearbyRestaurantWithLatitude:self.currentLocation.coordinate.latitude Longitude:self.currentLocation.coordinate.longitude Radius:10*83.1495 CompletionBlock:^{
        [self pushControllerWithName:@"WKNaviInterfaceController" context:nil];
    }];
}

- (IBAction)twentyMinuteButtonTapped {
    [FourSquareAPIClient getRandomNearbyRestaurantWithLatitude:self.currentLocation.coordinate.latitude Longitude:self.currentLocation.coordinate.longitude Radius:20*83.1495 CompletionBlock:^{
        [self pushControllerWithName:@"WKNaviInterfaceController" context:nil];
    }];
}

- (IBAction)thirtyMinuteButtonTapped {
    [FourSquareAPIClient getRandomNearbyRestaurantWithLatitude:self.currentLocation.coordinate.latitude Longitude:self.currentLocation.coordinate.longitude Radius:30*83.1495 CompletionBlock:^{
        
        [self pushControllerWithName:@"WKNaviInterfaceController" context:nil];
        
    }];
}




//-(id)contextForSegueWithIdentifier:(NSString *)segueIdentifier{
//    NSInteger *selectedTime = segueIdentifier.integerValue;
//    
//    
//    
//    
//    return nil;
//}


@end



