//
//  WikiArticle.m
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiArticle.h"

@implementation WikiArticle

- (instancetype) initWithPageID:(NSNumber*)pageID title:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate distance:(CLLocationDistance)distance {
    
    self = [super init];
    
    if (self) {
        
        _pageID = pageID;
        _title = title;
        _coordinate = coordinate;
        _distance = distance;
    }
    
    return self;
    
}

@end
