//
//  RestaurantCDObject.h
//  TrailMix
//
//  Created by Cong Sun on 7/31/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RestaurantCDObject : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSDate * createAt;
@property (nonatomic, retain) NSNumber * isVisited;

@end
