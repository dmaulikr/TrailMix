//
//  Restaurant.m
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "Restaurant.h"

@implementation Restaurant

-(instancetype)initWithName:(NSString *)name
                     rating:(NSString *)rating
                imageString:(NSString *)imageString
                    address:(NSString *)address
                   foodType:(NSString *)foodType
                   latitude:(NSString *)latitude
                  longitude:(NSString *)longitude
{
    self = [super init];
    
    if (self) {
        _name = name;
        _rating = rating;
        _imageString = imageString;
        _address = address;
        _foodType = foodType;
        _latitude = latitude;
        _longitude = longitude;
    }
    
    return self;
}

-(instancetype)init
{
    return [self initWithName:@"" rating:@"" imageString:@"" address:@"" foodType:@"" latitude:@"" longitude:@""];
}

+ (instancetype)createRestaurantObject:(NSDictionary *)restaurantDictionary
{
    //need to fix the catorgories
    Restaurant *restaurant = [[Restaurant alloc] initWithName:restaurantDictionary[@"name"]
                                                       rating:restaurantDictionary[@"rating_img_url"]
                                                  imageString:restaurantDictionary[@"image_url"]
                                                      address:restaurantDictionary[@"location"][@"address"]
                                                     foodType:restaurantDictionary[@"categories"][0][0]
                                                     latitude:restaurantDictionary[@"location"][@"coordinate"][@"latitude"]
                                                    longitude:restaurantDictionary[@"location"][@"coordinate"][@"longitude"]];
    
    return restaurant;
}


@end
