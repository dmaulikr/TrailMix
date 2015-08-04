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
#import "WikiTableViewController.h"
#import "DataStore.h"
#import "WikiAPIClient.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>

@interface NaviViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocation *destLocation;
@property (strong, nonatomic) CLLocation *restaurantLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) CLLocationDirection heading;
@property (strong, nonatomic) NSMutableArray *headingArray;
@property (nonatomic, strong) DataStore *dataStore;
@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    self.dataStore = [DataStore sharedDataStore];
    
    //change when select other transporation type
    self.locationManager.activityType = CLActivityTypeFitness;
    
    RestaurantCDObject *destRestaurant = [RestaurantCDObject getLatestRestaurant];
    
    [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%@",destRestaurant.name]];
    
    self.restaurantLocation = [[CLLocation alloc]initWithLatitude:destRestaurant.latitude.floatValue longitude:destRestaurant.longitude.floatValue];
    
    NSLog(@"%@",self.restaurantLocation);
    
    self.destLocation = self.restaurantLocation;
    
    [self startLocationService];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateDestination];
}

-(void)updateDestination{
    if(!self.dataStore.pointOfInterest){
        self.visitButton.enabled = NO;
        self.visitButton.alpha = 0;
    }else{
        self.visitButton.enabled = YES;
        self.visitButton.alpha = 1;
    }
    if(self.dataStore.destinationIsResaurant){
        [self showRestaurantDirection];
    }else{
        [self showAttractionDirection];
    }
}

-(void)showAttractionDirection{
    self.foodImage.image = [UIImage imageNamed:@"safari"];
    self.destLocation = [[CLLocation alloc]initWithLatitude:self.dataStore.pointOfInterest.coordinate.latitude longitude:self.dataStore.pointOfInterest.coordinate.longitude];
    [self.visitButton setTitle:@"Continue to Your Food" forState:UIControlStateNormal];
}

-(void)showRestaurantDirection{
    self.foodImage.image = [UIImage imageNamed:@"food"];
    self.destLocation = self.restaurantLocation;
    [self.visitButton setTitle:@"Visit This Place" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)headingArray{
    if(!_headingArray){
        _headingArray = [[NSMutableArray alloc]init];
    }
    return _headingArray;
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
    
    if (!self.dataStore.lastWikiUpdateLocation) {
        
        self.dataStore.lastWikiUpdateLocation = self.currentLocation;
        
        [self updateWikiArticles];
        
    } else {
        
        double distanceFromLastWikiUpdateLocation = [self.currentLocation distanceFromLocation:self.dataStore.lastWikiUpdateLocation];
        
//        [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%fm away from last wiki update location", distanceFromLastWikiUpdateLocation]];
        
        if (distanceFromLastWikiUpdateLocation > 400) { // every quarter mile?
            
            self.dataStore.lastWikiUpdateLocation = self.currentLocation;
            
            [self updateWikiArticles];
            
        }
        
    }
    
}

- (void) updateWikiArticles {
    
    CLLocationCoordinate2D coordinates = self.dataStore.lastWikiUpdateLocation.coordinate;
    [WikiAPIClient getArticlesAroundLocation:coordinates radius:400 completion:^(NSArray *wikiArticles) {
        
        self.dataStore.wikiArticles = wikiArticles;
        
//        [self.tableView reloadData];
        
//        [SVProgressHUD dismiss];
        
    }];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    self.heading = newHeading.trueHeading;
}
- (IBAction)visitButtonTapped:(id)sender {
    
//    if([self.visitButton.titleLabel.text isEqualToString:@"Visit This Place"]){
//        [self.visitButton setTitle:@"Continue to Your Food" forState:UIControlStateNormal];
//        self.foodImage.image = [UIImage imageNamed:@"safari"];
//        
//        CLLocation *location = [[CLLocation new] initWithLatitude:self.dataStore.pointOfInterest.coordinate.latitude longitude:self.dataStore.pointOfInterest.coordinate.latitude];
//        
//        self.destLocation = location;
//        
//    }else{
//        [self.visitButton setTitle:@"Visit This Place" forState:UIControlStateNormal];
//        self.foodImage.image = [UIImage imageNamed:@"food"];
//        self.destLocation = self.restaurantLocation;
//    }
    
    if(self.dataStore.destinationIsResaurant){
        [self showAttractionDirection];
        self.dataStore.destinationIsResaurant = NO;
    }else{
        [self showRestaurantDirection];
        self.dataStore.destinationIsResaurant = YES;
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
    CGFloat radianOffset = fabs(atan(xAxis/yAxis));
//    if(radianOffset<0) radianOffset = -radianOffset;
    
    if(yAxis>=0&&xAxis>=0){
        //        NSLog(@"1");
    }else if(yAxis<0&&xAxis>=0){
        radianOffset = M_PI - radianOffset;
        //        NSLog(@"2");
        
    }else if(xAxis<0&&yAxis>=0){
        //radianOffset = M_PI+radianOffset;
        radianOffset = radianOffset-M_PI;
        //        NSLog(@"3");
        
    }else{
        radianOffset = -radianOffset;
        
        //radianOffset = 2*M_PI-radianOffset;
        //        NSLog(@"4");
    }
    CGFloat aveHeading = [self calculateRotationRadian];
    
    CGFloat headingRadian = (-aveHeading*M_PI/180);
    self.foodImage.transform = CGAffineTransformMakeRotation(headingRadian+radianOffset);
}

-(CGFloat)calculateRotationRadian{
    CGFloat result = 0.0f;
    NSLog(@"this is %@",@(self.heading));
    CGFloat number = self.heading;
    if(number>180){
        number = number-360;
    }
    NSLog(@"this is %@",@(number));

    [self.headingArray addObject:@(number)];
    CGFloat baseNumber = ((NSNumber *)self.headingArray[0]).floatValue;
    
    
    if(self.headingArray.count>10){
        [self.headingArray removeObjectAtIndex:0];
    }
    for(NSNumber *number in self.headingArray){
        CGFloat offset = number.floatValue-baseNumber;
        if(offset>180){
            offset = offset-360;
        }
        if(offset<-180){
            offset = 360+offset;
        }
        result+= offset;
    }
    result = result/self.headingArray.count;
    
    NSLog(@"%f",result);
    return result+baseNumber;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
