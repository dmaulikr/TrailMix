//
//  RestaurantCDObject.h
//  TrailMix
//
//  Created by Cong Sun on 8/13/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RestaurantCDObject : NSManagedObject

@property (nonatomic, retain) NSDate * createAt;
@property (nonatomic, retain) NSNumber * isVisited;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * webUrl;

@end
