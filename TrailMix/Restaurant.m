//
//  Restaurant.m
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

- (instancetype) initWithCuisineType:(NSString *)foodType
                             VenueId:(NSString *)venueId
                                Name:(NSString *)name
                            Latitude:(NSString *)latitude
                           Longitude:(NSString *)longitude
                         DollarSigns:(NSString *)dollarSigns;
{
    self = [super init];
    
    if (self) {
        _foodType = foodType;
        _venueId = venueId;
        _name = name;
        _latitude = latitude;
        _longitude = longitude;
        _dollarSigns = @(dollarSigns.integerValue-1);
    }
    
    return self;
}

+ (instancetype)createRestaurantObject:(NSDictionary *)restaurantDictionary

{
        Restaurant *restaurant = [[Restaurant alloc] initWithCuisineType:restaurantDictionary[@"venue"][@"categories"][0][@"shortName"] VenueId:restaurantDictionary[@"venue"][@"categories"][0][@"id"] Name:restaurantDictionary[@"venue"][@"name"] Latitude:restaurantDictionary[@"venue"][@"location"][@"lat"] Longitude:restaurantDictionary[@"venue"][@"location"][@"lng"] DollarSigns:restaurantDictionary[@"venue"][@"price"][@"tier"]];
        
    return restaurant;
    
}


@end
