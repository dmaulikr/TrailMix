//
//  Restaurant.h
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *rating;
//@property (nonatomic, strong) NSString *imageString;
//@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *foodType;
//@property (nonatomic, strong) NSString *latitude;
//@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *venueId;

//-(instancetype)initWithName:(NSString *)name
//                     Rating:(NSString *)rating
//                ImageString:(NSString *)imageString
//                    Address:(NSString *)address
//                   FoodType:(NSString *)foodType
//                   Latitude:(NSString *)latitude
//                  Longitude:(NSString *)longitude
//                    VenueId:(NSString *)venueID;

- (instancetype) initWithCuisineType:(NSString *)foodType
                             VenueId:(NSString *)venueId;

+ (instancetype)createRestaurantObject:(NSDictionary *)restaurantDictionary;
@end
