//
//  FilterViewController.h
//  TrailMix
//
//  Created by Mason Macias on 8/6/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface FilterViewController : UIViewController

@property (assign, nonatomic) NSInteger timeInMinute;
@property (assign, nonatomic) double currentLatitude;
@property (assign, nonatomic) double currentLongitude;

@end
