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
    
    NSString *fourSquareURL = [NSString stringWithFormat:@"%@%@?client_id=%@&client_secret=%@&%@",FOURSQUARE_BASE_URL, FOURSQUARE_VENUES_SEARCH, FOURSQUARE_CONSUMER_KEY, FOURSQUARE_CONSUMER_SECRET,FOURSQUARE_DOLLARSIGNS];
    
    AFHTTPSessionManager *clientManager = [AFHTTPSessionManager manager];
    
    [clientManager GET:fourSquareURL parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *responseDictionary = responseObject;
        NSArray *restaurantDictionaries = responseDictionary[@"response"][@"groups"][0][@"items"];
        NSMutableDictionary *cuisineTypeWithRestaurantObjects = [DataStore sharedDataStore].restaurantDictionary;
        for (NSDictionary *restaurant in restaurantDictionaries){
            NSNumber *isOpen = @1;
                NSNumber *ifRestaurantIsOpen = restaurant[@"venue"][@"hours"][@"isOpen"];
            NSNumber *validDollarSign = restaurant[@"venue"][@"price"][@"tier"];
                if ([ifRestaurantIsOpen isEqualToNumber: isOpen] && validDollarSign.intValue >= 1 && validDollarSign.intValue <= 4){
                    Restaurant *restaurantObject = [Restaurant createRestaurantObject:restaurant];
                    
                    if (cuisineTypeWithRestaurantObjects[restaurantObject.foodType]){
                        
                        [(NSMutableArray *)cuisineTypeWithRestaurantObjects[restaurantObject.foodType]addObject:restaurantObject];
                        
                    } else {
                        
                        NSMutableArray *array = [NSMutableArray array];
                        [array addObject:restaurantObject];
                        [cuisineTypeWithRestaurantObjects setObject:array forKey:restaurantObject.foodType];
                    }

            }
                                }
        
        NSLog(@"before call back %@",[DataStore sharedDataStore].restaurantDictionary);
        [DataStore sharedDataStore].selectedFoodTypes = [[NSMutableArray alloc]initWithArray:cuisineTypeWithRestaurantObjects.allKeys];
        completionBlock();
        
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
