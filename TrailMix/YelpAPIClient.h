//
//  YelpAPIClient.h
//  TrailMix
//
//  Created by Mason Macias on 7/29/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface YelpAPIClient : BDBOAuth1RequestOperationManager

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSString *radius;


+ (instancetype)sharedYelpClient;

- (AFHTTPRequestOperation *)searchForTerm:(NSString *)term success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)searchForTerm:(NSString *)term options:(NSDictionary *)options success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

