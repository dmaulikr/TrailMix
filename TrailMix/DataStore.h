//
//  DataStore.h
//  TrailMix
//
//  Created by Cong Sun on 7/30/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//
@class Restaurant;
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "WikiArticle.h"


@interface DataStore : NSObject

+(instancetype) sharedDataStore;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *selectedFoodTypes;
@property (strong, nonatomic) NSMutableDictionary *restaurantDictionary;
@property (nonatomic, strong) NSArray *wikiArticles;
@property (nonatomic, strong) CLLocation *lastWikiUpdateLocation;
@property (nonatomic, strong) WikiArticle *pointOfInterest;
@property (assign, nonatomic) NSInteger dollarPref;
@property (assign, nonatomic) NSInteger starPref;
@property (assign, nonatomic) BOOL destinationIsResaurant;
@property (nonatomic, strong) Restaurant *selectedRestaurant;
@property (nonatomic) BOOL skipAnimation;
-(void)saveContext;

-(void)filteredRestaurant;

-(NSArray *)filteredRestaurantArray;


@end
