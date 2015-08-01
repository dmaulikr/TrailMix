//
//  NaviViewController.m
//  CoreLocationPractice
//
//  Created by Cong Sun on 7/29/15.
//  Copyright (c) 2015 Cong Sun. All rights reserved.
//

#import "NaviViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RestaurantCDObject+InitWithRestaurantObject.h"

@interface NaviViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocation *destLocation;
@property (strong, nonatomic) CLLocation *attractionLocation;
@property (strong, nonatomic) CLLocation *restaurantLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) CLLocationDirection heading;
@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    //change when select other transporation type
    self.locationManager.activityType = CLActivityTypeFitness;
    
    RestaurantCDObject *destRestaurant = [RestaurantCDObject getLatestRestaurant];
    
    self.restaurantLocation = [[CLLocation alloc]initWithLatitude:destRestaurant.latitude.floatValue longitude:destRestaurant.longitude.floatValue];
    
    NSLog(@"%@",self.restaurantLocation);
    
    self.attractionLocation = [[CLLocation alloc]initWithLatitude:40.7764584 longitude:-73.9624175];
    
    self.destLocation = self.restaurantLocation;
    
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

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    //do something to shows if authorizatrion failed
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.currentLocation = (CLLocation *)locations[0];
//    CLLocationDistance distance = [self.destLocation distanceFromLocation:self.currentLocation];
//    self.distanceLabel.text = [NSString stringWithFormat:@"Remaining Distance: %f",distance];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
//    CGFloat xAxis = self.destLocation.coordinate.longitude - self.currentLocation.coordinate.longitude;
//    CGFloat yAxis = self.destLocation.coordinate.latitude - self.currentLocation.coordinate.latitude;
//    CGFloat radianOffset = atan(yAxis/xAxis);
//    if(radianOffset<0) radianOffset = -radianOffset;
//    
//    if(yAxis>=0&&xAxis>=0){
////        NSLog(@"1");
//    }else if(yAxis<0&&xAxis>=0){
//        radianOffset = M_PI - radianOffset;
////        NSLog(@"2");
//        
//    }else if(xAxis<0&&yAxis>=0){
//        radianOffset = -radianOffset;
////        NSLog(@"3");
//        
//    }else{
//        radianOffset = radianOffset - M_PI;
////        NSLog(@"4");
//    }
//    
    self.heading = newHeading.trueHeading;
//    CGFloat headingRadian = (-self.heading*M_PI/180);
//    self.foodImage.transform = CGAffineTransformMakeRotation(headingRadian+radianOffset);
//    self.compassImage.transform = CGAffineTransformMakeRotation(headingRadian);
    
}
- (IBAction)visitButtonTapped:(id)sender {
    
    if([self.visitButton.titleLabel.text isEqualToString:@"Visit This Place"]){
        [self.visitButton setTitle:@"Continue to Your Food" forState:UIControlStateNormal];
        self.foodImage.image = [UIImage imageNamed:@"safari"];
        self.destLocation = self.attractionLocation;
    }else{
        [self.visitButton setTitle:@"Visit This Place" forState:UIControlStateNormal];
        self.foodImage.image = [UIImage imageNamed:@"food"];
        self.destLocation = self.restaurantLocation;
    }
}

-(void)setDestLocation:(CLLocation *)destLocation{
    _destLocation = destLocation;
    [self updateCompass];
}

-(void)setHeading:(CLLocationDirection)heading{
    _heading = heading;
    [self updateHeader];
    
}

-(void)updateCompass{
    [self updateDistance];
    [self updateHeader];
    
}

-(void)setCurrentLocation:(CLLocation *)currentLocation{
    _currentLocation = currentLocation;
    [self updateDistance];
}


-(void)updateDistance{
    CLLocationDistance distance = [self.destLocation distanceFromLocation:self.currentLocation];
    self.distanceLabel.text = [NSString stringWithFormat:@"Remaining Distance: %f",distance];
}

-(void)updateHeader{
    CGFloat xAxis = self.destLocation.coordinate.longitude - self.currentLocation.coordinate.longitude;
    CGFloat yAxis = self.destLocation.coordinate.latitude - self.currentLocation.coordinate.latitude;
    CGFloat radianOffset = atan(yAxis/xAxis);
    if(radianOffset<0) radianOffset = -radianOffset;
    
    if(yAxis>=0&&xAxis>=0){
        //        NSLog(@"1");
    }else if(yAxis<0&&xAxis>=0){
        radianOffset = M_PI - radianOffset;
        //        NSLog(@"2");
        
    }else if(xAxis<0&&yAxis>=0){
        radianOffset = -radianOffset;
        //        NSLog(@"3");
        
    }else{
        radianOffset = radianOffset - M_PI;
        //        NSLog(@"4");
    }
    
    CGFloat headingRadian = (-self.heading*M_PI/180);
    self.foodImage.transform = CGAffineTransformMakeRotation(headingRadian+radianOffset);
}

- (CLLocationDegrees) offsetOfTargetLocation:(CLLocation *)targetLocation fromLocation:(CLLocation*)referenceLocation {
    
    // Give an offset in degrees away from north
    
    double offsetRadians = 0;
    
    
    double tarLat = targetLocation.coordinate.latitude;
    double tarLng = targetLocation.coordinate.longitude;
    
    double curLat = referenceLocation.coordinate.latitude;
    double curLng = referenceLocation.coordinate.longitude;
    
    double deltaY = tarLat - curLat;
    double deltaX = tarLng - curLng;
    
    // We need to calculate arc tan and arrange it depending on quadrant
    // tan(θ) = Opposite / Adjacent
    
    // Quadrants
    //    lat   +,+
    // VI  |  I
    // -------- long
    // III | II +,-
    
    // Lat = y Coords
    // Long = x Coords
    
    if (tarLat > curLat && tarLng > curLng) { // Quadrant I
        
        offsetRadians = atan(fabs(deltaX / deltaY));
        
    } else if (tarLat < curLat && tarLng > curLng) { // Quadrant II
        
        offsetRadians = (M_PI / 2) + atan(fabs(deltaY / deltaX));
        
    } else if (tarLat < curLat && tarLng < curLng) { // Quadrant III
        
        offsetRadians = M_PI + atan(fabs(deltaX / deltaY));
        
    } else if (tarLat > curLat && tarLng < curLng) { // Quadrant IV
        
        offsetRadians = (3 * M_PI / 2) + atan(fabs(deltaY / deltaX));
        
    } else if (tarLat > curLat && deltaX == 0) { // Directly North
        
        // offset is zero for north
        
    } else if (tarLat < curLat && deltaX == 0) { // Directly South
        
        offsetRadians = M_PI;
        
    } else if (deltaY == 0 && tarLng < curLng) { // Directly West
        
        offsetRadians = 3 * M_PI / 2;
        
    } else if (deltaY == 0 && tarLng > curLng) { // Directly East
        
        offsetRadians = M_PI / 2;
        
    }
    
    CLLocationDegrees offsetDegress = offsetRadians * ( 180.0 / M_PI );
    
    return offsetDegress;
    
}
//-(void)setDestLocation:(CLLocation *)destLocation{
//    _destLocation = destLocation;
//    [self startLocationService];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
