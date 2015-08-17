//
//  NaviViewController.m
//  CoreLocationPractice
//
//  Created by Cong Sun on 7/29/15.
//  Copyright (c) 2015 Cong Sun. All rights reserved.
//

#import "NaviViewController.h"
#import <FAKFontAwesome.h>
#import <CoreLocation/CoreLocation.h>
#import "RestaurantCDObject+InitWithRestaurantObject.h"
#import "WikiTableViewController.h"
#import "DataStore.h"
#import "WikiAPIClient.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import "FilterViewController.h"
#import "RestaurantDestinationWebViewController.h"
#import "Restaurant.h"
#import <AudioToolbox/AudioServices.h>

@interface NaviViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocation *destLocation;
@property (strong, nonatomic) CLLocation *restaurantLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *visitButton;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (assign, nonatomic) CLLocationDirection heading;
@property (strong, nonatomic) NSMutableArray *headingArray;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *followArrowLabel;
@property (nonatomic, strong) DataStore *dataStore;
@property (weak, nonatomic) IBOutlet UIButton *cancelTripButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (nonatomic) BOOL destinationReached;
@property (weak, nonatomic) IBOutlet UIButton *placeNearbyButton;
@property (nonatomic) BOOL animationHappened;
@property (strong, nonatomic) RestaurantCDObject *destRestaurantCDObject;
@property (strong, nonatomic) FAKFontAwesome *pauseIcon;
@property (weak, nonatomic) IBOutlet UIView *cancelPauseMeterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followTheArrowConstraint;
@property (strong, nonatomic) FAKFontAwesome *cancelIcon;
@property (strong, nonatomic) FAKFontAwesome *forkAndKnifeIcon;
@end

@implementation NaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeButtonIcons];
    self.arrowView.backgroundColor = [UIColor clearColor];
    self.arrowLabel.adjustsFontSizeToFitWidth = YES;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    self.dataStore = [DataStore sharedDataStore];
    
    //change when select other transporation type
    self.locationManager.activityType = CLActivityTypeFitness;
    
    self.destRestaurantCDObject = [RestaurantCDObject getLatestRestaurant];
    
//    [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%@",destRestaurant.name]];
    
    self.restaurantLocation = [[CLLocation alloc]initWithLatitude:self.destRestaurantCDObject.latitude.floatValue longitude:self.destRestaurantCDObject.longitude.floatValue];
    
    NSLog(@"%@",self.restaurantLocation);
    
    self.destLocation = self.restaurantLocation;
    
    [self startLocationService];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self animateIntro];
}

-(void)animateIntro
{
    if(!self.dataStore.skipAnimation){
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.followArrowLabel.alpha = 1;
            self.followArrowLabel.font = [UIFont fontWithName:@"Avenir-Book" size:40];
            self.followTheArrowConstraint.constant = -170;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            if (finished) {
                NSLog(@"finished");
                [UIView animateWithDuration:0.75 delay:1.25 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.cancelPauseMeterView.alpha = 1;
                    self.placeNearbyButton.alpha = 1;
                    self.distanceLabel.alpha = 1;
                    self.pauseButton.alpha = 1;
                    self.cancelTripButton.alpha = 1;
                    self.followArrowLabel.alpha = 0;
                    self.followTheArrowConstraint.constant = -238;
                    [self.view layoutIfNeeded];
                    
                } completion:^(BOOL finished){
                    
                    self.dataStore.skipAnimation = YES;
                }];
            }
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateDestination];
}

- (IBAction)abortButtonTapped:(UIStoryboardSegue *)sender {
    self.dataStore.skipAnimation = NO;
    [[DataStore sharedDataStore].managedObjectContext deleteObject:self.destRestaurantCDObject];
    [[DataStore sharedDataStore] saveContext];
    
    UINavigationController *controller = (UINavigationController *)self.presentingViewController;
    [controller popToRootViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}
- (IBAction)pauseButtonTapped:(UIStoryboardSegue *)sender {
    self.dataStore.skipAnimation = NO;
    UINavigationController *controller = (UINavigationController *)self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:nil];
    [controller popToRootViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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

-(void)makeButtonIcons
{
    self.cancelIcon = [FAKFontAwesome timesIconWithSize:40];
    [self.cancelIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:45.0/255.0 green:47.0/255.0 blue:51.0/255.0 alpha:1]];
    [self.cancelTripButton setAttributedTitle:[self.cancelIcon attributedString] forState:UIControlStateNormal];
    self.pauseIcon = [FAKFontAwesome pauseIconWithSize:30];
    [self.pauseIcon addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:45.0/255.0 green:47.0/255.0 blue:51.0/255.0 alpha:1]];
    [self.pauseButton setAttributedTitle:[self.pauseIcon attributedString] forState:UIControlStateNormal];

}
-(void)showAttractionDirection{
    self.destLocation = [[CLLocation alloc]initWithLatitude:self.dataStore.pointOfInterest.coordinate.latitude longitude:self.dataStore.pointOfInterest.coordinate.longitude];
    [self.visitButton setTitle:@"Continue to Restaurant" forState:UIControlStateNormal];
}

-(void)showRestaurantDirection{
    self.destLocation = self.restaurantLocation;
    self.visitButton.alpha = 0;

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
    
    
    if ([self.currentLocation distanceFromLocation:self.restaurantLocation] <= 30.0) { // if we're less then 30 meters away then we'll let the user know we're here!
        
        if (!self.destinationReached && self.dataStore.skipAnimation) { // if the animation is complete for the follow the arrow then we can show the modal
            
            self.destinationReached = YES;
            
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            
            [self performSegueWithIdentifier:@"DestinationReachedSegue" sender:self];
            
        }
        
        
    }
    
}

- (void) updateWikiArticles {
    
    CLLocationCoordinate2D coordinates = self.dataStore.lastWikiUpdateLocation.coordinate;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    NSNotification *startedNotification = [NSNotification notificationWithName:@"didStartGettingArticlesAroundLocation" object:nil userInfo:nil];
    
    [notificationCenter postNotification:startedNotification];

    
    [WikiAPIClient getArticlesAroundLocation:coordinates radius:400 completion:^(NSArray *wikiArticles) {
        
        self.dataStore.wikiArticles = wikiArticles;
        
        NSNotification *finishedNotification = [NSNotification notificationWithName:@"didFinishGettingArticlesAroundLocation" object:nil userInfo:nil];
        
        [notificationCenter postNotification:finishedNotification];
        
//        [self.tableView reloadData];
        
//        [SVProgressHUD dismiss];
        
    }];
    
}
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    
    return YES;
    
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
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f Meters",distance];
}

-(void)updateHeader{
    
    CLLocationDegrees destinationOffset = [self offsetOfTargetLocation:self.destLocation fromLocation:self.currentLocation];
    
//    CGFloat xAxis = self.destLocation.coordinate.longitude - self.currentLocation.coordinate.longitude;
//    CGFloat yAxis = self.destLocation.coordinate.latitude - self.currentLocation.coordinate.latitude;
//    CGFloat radianOffset = fabs(atan(xAxis/yAxis));
////    if(radianOffset<0) radianOffset = -radianOffset;
//    
//    if(yAxis>=0&&xAxis>=0){
//        //        NSLog(@"1");
//    }else if(yAxis<0&&xAxis>=0){
//        radianOffset = M_PI - radianOffset;
//        //        NSLog(@"2");
//        
//    }else if(xAxis<0&&yAxis>=0){
//        //radianOffset = M_PI+radianOffset;
//        radianOffset = radianOffset-M_PI;
//        //        NSLog(@"3");
//        
//    }else{
//        radianOffset = -radianOffset;
//        
//        //radianOffset = 2*M_PI-radianOffset;
//        //        NSLog(@"4");
//    }
    CGFloat aveHeading = [self calculateRotationRadian];
    
    CGFloat headingRadian = ((0-aveHeading+destinationOffset)*M_PI/180);
    self.arrowView.transform = CGAffineTransformMakeRotation(headingRadian);
//    self.foodImage.transform = CGAffineTransformMakeRotation(headingRadian);
}

-(CGFloat)calculateRotationRadian{
    CGFloat result = 0.0f;
//    NSLog(@"this is %@",@(self.heading));
    CGFloat number = self.heading;
    if(number>180){
        number = number-360;
    }
//    NSLog(@"this is %@",@(number));

    [self.headingArray addObject:@(number)];
    CGFloat baseNumber = ((NSNumber *)self.headingArray[0]).floatValue;
    
    
    if(self.headingArray.count>5){
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
    
//    NSLog(@"%f",result);
    return result+baseNumber;
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"DestinationReachedSegue"]) {
        
        RestaurantDestinationWebViewController *restaurantDesinationWebViewController = segue.destinationViewController;
        
        RestaurantCDObject *restaurant = (RestaurantCDObject*)[RestaurantCDObject getLatestRestaurant];
        
        restaurantDesinationWebViewController.url = [NSURL URLWithString:restaurant.webUrl];
        
    }
    
}


@end
