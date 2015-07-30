//
//  YelpAPIClient.h
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"
#import "Restaurant.h"
@interface YelpAPIClient : BDBOAuth1RequestOperationManager

+ (instancetype)sharedYelpClient;


//- (AFHTTPRequestOperation *)searchForTerm:(NSString *)term options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)getCuisineTypesAndRestaurantWithLatitude:(double)latitude
                                  Longitude:(double)longitude
                                     Radius:(double)radius
                            CompletionBlock:(void(^)(void))completionBlock;
@end

