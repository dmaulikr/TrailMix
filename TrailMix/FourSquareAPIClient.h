//
//  FourSquareAPIClient.h
//  TrailMix
//
//  Created by Mason Macias on 7/31/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurant.h"
@interface FourSquareAPIClient : NSObject

+(void)getNearbyRestaurantWithLatitude:(double)latitude
                             Longitude:(double)longitude
                                Radius:(double)radius
                       CompletionBlock:(void(^)(void))completionBlock;

+(void)getRestaurantInfoWithId:(NSString *)venueId CompletionBlock:(void(^)(Restaurant *restaurant))completionBlock;

+(NSString *)getCurrentDateForGetRequest;

@end
