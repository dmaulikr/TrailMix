//
//  RestaurantPreferenceTableViewController.h
//  TrailMix
//
//  Created by Cong Sun on 7/30/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface RestaurantPreferenceTableViewController : UITableViewController

@property (assign, nonatomic) NSInteger timeInMinute;
@property (assign, nonatomic) double currentLatitude;
@property (assign, nonatomic) double currentLongitude;

@end
