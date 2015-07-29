//
//  WikiAPI.m
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiAPI.h"
#import <AFNetworking/AFNetworking.h>

@implementation WikiAPI

+ (void) getArticlesAroundLocation:(CLLocationCoordinate2D)coordinate completion:(void(^)(NSArray*wikiArticles))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"action" : @"query",
                                 @"format" : @"json",
                                 @"list" : @"geosearch",
                                 @"gsradius" : @100,
                                 @"gscoord" : [NSString stringWithFormat:@"%f|%f",coordinate.latitude, coordinate.longitude]
                                 };
    
    [manager GET:@"https://en.wikipedia.org/w/api.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *geosearch = responseObject[@"query"][@"geosearch"];
        
        NSMutableArray *articles = [NSMutableArray new];
        
        for (NSDictionary *dic in geosearch) {
            
            NSNumber *pageID = dic[@"pageid"];
            NSString *title = dic[@"title"];
            double lat = [dic[@"lat"] doubleValue];
            double lng = [dic[@"lon"] doubleValue];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
            CLLocationDistance distance = [dic[@"dist"] doubleValue];
            
            WikiArticle *article = [[WikiArticle alloc] initWithPageID:pageID title:title coordinate:coordinate distance:distance];
            
            [articles addObject:article];
            
        }
        
        completion(articles);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // need to implement failure
        
    }];
    
}

+ (void) getArticleExtract:(NSNumber *)articleID completion:(void(^)(NSString *extract))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"action" : @"query",
                                 @"format" : @"json",
                                 @"prop" : @"extracts",
                                 @"exintro" : @"",
                                 @"explaintext" : @"",
                                 @"pageids" : articleID
                                 };
    
    [manager GET:@"https://en.wikipedia.org/w/api.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    
        NSDictionary *article = responseObject[@"query"][@"pages"][[articleID stringValue]];
    
        
        completion(article[@"extract"]);
        
     
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
         // need to implement failure
         
     }];

}

@end
