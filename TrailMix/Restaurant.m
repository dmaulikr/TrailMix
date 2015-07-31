//
//  Restaurant.m
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

//-(instancetype)initWithName:(NSString *)name
//                     Rating:(NSString *)rating
//                ImageString:(NSString *)imageString
//                    Address:(NSString *)address
//                   FoodType:(NSString *)foodType
//                   Latitude:(NSString *)latitude
//                  Longitude:(NSString *)longitude
//                    VenueId:(NSString *)venueID
//{
//    self = [super init];
//
//    if (self) {
//        _name = name;
//        _rating = rating;
//        _imageString = imageString;
//        _address = address;
//        _foodType = foodType;
//        _latitude = latitude;
//        _longitude = longitude;
//        _venueId = venueID;
//    }
//
//    return self;
//}

//-(instancetype)init
//{
//    return [self initWithName:@""
//                       Rating:@""
//                  ImageString:@""
//                      Address:@""
//                     FoodType:@""
//                     Latitude:@""
//                    Longitude:@""
//                      VenueId:@""];
//}

-(instancetype)initWithCuisineType:(NSString *)foodType
                           VenueId:(NSString *)venueId
{
    self = [super init];
    
    if (self) {
        _foodType = foodType;
        _venueId = venueId;
    }
    
    return self;
}

-(instancetype)init

{
    return [self initWithCuisineType:@"" VenueId:@""];
}

+ (instancetype)createRestaurantObject:(NSDictionary *)restaurantDictionary

{
    
    Restaurant *restaurant = [[Restaurant alloc] initWithCuisineType:restaurantDictionary[@"categories"][0][@"shortName"] VenueId:restaurantDictionary[@"id"]];
    
    return restaurant;
}
@end
