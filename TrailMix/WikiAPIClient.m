//
//  WikiAPI.m
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiAPIClient.h"
#import <AFNetworking/AFNetworking.h>

@implementation WikiAPIClient

+ (void) getArticlesAroundLocation:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius completion:(void(^)(NSArray*wikiArticles))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"action" : @"query",
                                 @"format" : @"json",
                                 @"list" : @"geosearch",
                                 @"gsradius" : @(radius),
                                 @"gslimit" : @500, // high amount will cause memory warning
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
        completion(nil);
        
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
        completion(nil);
        
    }];
    
}

+ (void) getArticleImageList:(NSNumber *)articleID completion:(void(^)(NSArray *imageList))completion {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"action" : @"query",
                                 @"format" : @"json",
                                 @"prop" : @"images",
                                 @"pageids" : articleID
                                 };
    
    [manager GET:@"https://en.wikipedia.org/w/api.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *imageList = responseObject[@"query"][@"pages"][[articleID stringValue]][@"images"];
        
        //        NSArray *array = [NSArray arrayWithObject:[NSMutableDictionary dictionaryWithObject:@"filter string" forKey:@"email"]];   // you can also do same for Name key...
        NSArray *filteredarray = [imageList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title CONTAINS[c] %@)", @".jpg"]];
        
        //        NSLog(@"%@",filteredarray);
        
        completion(filteredarray);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // need to implement failure
        NSLog(@"%@",error);
        
        completion(nil);
        
    }];
    
}

+ (void) getArticleImageURL:(NSNumber *)articleID completion:(void(^)(NSURL *imageURL))completion {
    
    [WikiAPIClient getArticleImageList:articleID completion:^(NSArray *imageList) {
        
        if (imageList.count > 0) {
            
            NSString *fileName = [imageList firstObject][@"title"];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            NSDictionary *parameters = @{
                                         @"action" : @"query",
                                         @"format" : @"json",
                                         @"prop" : @"imageinfo",
                                         @"iiprop" : @"url",
                                         @"titles" : fileName
                                         };
            
            [manager GET:@"https://en.wikipedia.org/w/api.php" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSArray *responseValues = [responseObject[@"query"][@"pages"] allValues]; // only one value
                // strangly we get -1 back for some dictionaries...
                
                NSString *urlString = [responseValues firstObject][@"imageinfo"][0][@"url"];
                
                //        NSLog(@"%@",urlString);
                
                NSURL *url = [NSURL URLWithString:urlString];
                
                completion(url);
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                // need to implement failure
                NSLog(@"%@",error);
                
                completion(nil);
                
            }];
            
        } else {
            
            completion(nil);
            
        }
        
        
    }];
    
    
    
}



@end
