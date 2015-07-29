//
//  Restaurant.h
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *foodType;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

- (instancetype) initWithName:(NSString *)name
                       rating:(NSString *)rating
                  imageString:(NSString *)imageString
                      address:(NSString *)address
                     foodType:(NSString *)foodType
                     latitude:(NSString *)latitude
                    longitude:(NSString *)longitude;

+ (instancetype)createRestaurantObject:(NSDictionary *)restaurantDictionary;

@end
