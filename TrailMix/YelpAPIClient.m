//
//  YelpAPIClient.m
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "YelpAPIClient.h"
#import "Constants.h"
#import "DataStore.h"
@implementation YelpAPIClient


+ (instancetype)sharedYelpClient {
    static YelpAPIClient *_sharedYelpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedYelpClient = [[YelpAPIClient alloc] initWithConsumerKey:YELP_CONSUMER_KEY consumerSecret:YELP_CONSUMER_SECRET accessToken:YELP_TOKEN accessSecret:YELP_TOKEN_SECRET];
    });
    
    return _sharedYelpClient;
}

- (id)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken accessSecret:(NSString *)accessSecret {
    NSURL *baseURL = [NSURL URLWithString:@"http://api.yelp.com/v2/"];
    self = [super initWithBaseURL:baseURL consumerKey:consumerKey consumerSecret:consumerSecret];
    if (self) {
        BDBOAuth1Credential *token = [BDBOAuth1Credential credentialWithToken:accessToken secret:accessSecret expiration:nil];
        [self.requestSerializer saveAccessToken:token];
    }
    return self;
}
//FIX THIS
- (AFHTTPRequestOperation *)searchForRestaurants:(double)latitude
                                       longitude:(double)longitude
                                          radius:(double)radius
                                         success:(void (^)(AFHTTPRequestOperation *operation, id response))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
    NSString *coordinates = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSString *radiusFilter = [NSString stringWithFormat:@"%f", radius];
    NSDictionary *parameters = @{@"term": @"restaurant", @"ll" : coordinates, @"radius_filter": radiusFilter};
    
    return [self GET:@"search" parameters:parameters success:success failure:failure];
}

+ (void)getCuisineTypesAndRestaurantWithLatitude:(double)latitude
                                 Longitude:(double)longitude
                                    Radius:(double)radius
                           CompletionBlock:(void(^)(void))completionBlock
{
    YelpAPIClient *client = [[YelpAPIClient alloc] initWithConsumerKey:YELP_CONSUMER_KEY consumerSecret:YELP_CONSUMER_SECRET accessToken:YELP_TOKEN accessSecret:YELP_TOKEN_SECRET];
    
    [client searchForRestaurants:latitude longitude:longitude radius:radius success:^(AFHTTPRequestOperation *operation, id response) {
        NSDictionary *responseDictionary = response;
        NSArray *restaurantDictionaries = responseDictionary[@"businesses"];
        
        NSMutableDictionary *cuisineTypeDictWithRestaurantObjects = [DataStore sharedDataStore].restaurantDictionary;
        for (NSDictionary *restaurant in restaurantDictionaries) {
            Restaurant *restaurantObject = [Restaurant createRestaurantObject:restaurant];
            if(cuisineTypeDictWithRestaurantObjects[restaurantObject.foodType]){
                [(NSMutableArray *)cuisineTypeDictWithRestaurantObjects[restaurantObject.foodType] addObject:restaurantObject];
            }else{
                NSMutableArray *array = [[NSMutableArray alloc]init];
                [array addObject:restaurantObject];
                [cuisineTypeDictWithRestaurantObjects setObject:array forKey:restaurantObject.foodType];
            }
        }
        NSLog(@"%@",cuisineTypeDictWithRestaurantObjects);
        completionBlock();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
    
    
    
    
}

//- (AFHTTPRequestOperation *)searchForTerm:(NSString *)term options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
//    
//    NSLog(@"Applying Filters.....");
//    
//    NSString *coordinates = [NSString stringWithFormat:@"%f,%f", self.latitude, self.longitude];
//    
//    NSMutableDictionary *parameters = [@{@"term": term, @"ll" : coordinates, @"radius_filter": self.radius} mutableCopy];
//    
//    if (!options) {
//        if (options[@"deals_filter"]) {
//            parameters[@"deals_filter"] = options[@"deals_filter"];
//        }
//        if (options[@"sort"]) {
//            parameters[@"sort"] = options[@"sort"];
//        }
//        
//        if (options[@"category_filter"]) {
//            parameters[@"category_filter"] = options[@"category_filter"];
//        }
//    }
//    return [self GET:@"search" parameters:parameters success:success failure:failure];
//}







@end

