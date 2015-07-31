//
//  FourSquareAPIClient.m
//  TrailMix
//
//  Created by Mason Macias on 7/31/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "FourSquareAPIClient.h"
#import "Constants.h"
#import <AFNetworking.h>
#import "Restaurant.h"
#import "DataStore.h"
@implementation FourSquareAPIClient

+(void)getNearbyRestaurantWithLatitude:(double)latitude
                             Longitude:(double)longitude
                                Radius:(double)radius
                       CompletionBlock:(void(^)(void))completionBlock
{
    NSDictionary *params = @{@"v":[self getCurrentDateForGetRequest],
                             @"radius":[NSString stringWithFormat:@"%f",radius],
                             @"ll":[NSString stringWithFormat:@"%f,%f",latitude, longitude],
                             @"query":FOURSQUARE_RESTAURANT_SEARCH};
    
    NSString *fourSquareURL = [NSString stringWithFormat:@"%@%@?client_id=%@&client_secret=%@",FOURSQUARE_BASE_URL, FOURSQUARE_VENUES_SEARCH, FOURSQUARE_CONSUMER_KEY, FOURSQUARE_CONSUMER_SECRET];
    
    AFHTTPSessionManager *clientManager = [AFHTTPSessionManager manager];
    
    [clientManager GET:fourSquareURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDictionary = responseObject;
        NSArray *restaurantDictionaries = responseDictionary[@"response"][@"venues"];
        NSMutableDictionary *cuisineTypeWithRestaurantObjects = [DataStore sharedDataStore].restaurantDictionary;
        for (NSDictionary *restaurant in restaurantDictionaries){
            
            Restaurant *restaurantObject = [Restaurant createRestaurantObject:restaurant];
            
            if (cuisineTypeWithRestaurantObjects[restaurantObject.foodType]) {
                
                [(NSMutableArray *)cuisineTypeWithRestaurantObjects[restaurantObject.foodType]addObject:restaurantObject];
            } else {
                
                NSMutableArray *array = [NSMutableArray array];
                [array addObject:restaurantObject];
                [cuisineTypeWithRestaurantObjects setObject:array forKey:restaurantObject.foodType];
            }
        }
        
        completionBlock();
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error.description);
    }];
    
    
    
}

+(void)getRestaurantInfoWithId:(NSString *)venueId CompletionBlock:(void(^)(void))completionBlock
{
    NSString *fourSquareURL = [NSString stringWithFormat:@"%@%@%@?client_id=%@&client_secret=%@",FOURSQUARE_BASE_URL, FOURSQUARE_VENUES_DETAIL,venueId, FOURSQUARE_CONSUMER_KEY, FOURSQUARE_CONSUMER_SECRET];
    NSDictionary *params = @{@"v":[self getCurrentDateForGetRequest]};
    AFHTTPSessionManager *clientManager = [AFHTTPSessionManager manager];
    
    [clientManager GET:fourSquareURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDictionary = responseObject;
        
        [Restaurant createRestaurantDetailObject:responseDictionary];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error.description);
    }];

    
}

+(NSString *)getCurrentDateForGetRequest
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *now = [NSDate date];
    NSString *dateString = [dateFormat stringFromDate:now];
    
    return dateString;
}


@end
