//
//  RestaurantCDObject+InitWithRestaurantObject.m
//  TrailMix
//
//  Created by Cong Sun on 7/31/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "Restaurant.h"
#import "DataStore.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"

@implementation RestaurantCDObject (InitWithRestaurantObject)

-(void)initWithRestaurantObject:(Restaurant *)restaurant{
    
    RestaurantCDObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"RestaurantCDObject" inManagedObjectContext:[DataStore sharedDataStore].managedObjectContext];
    
    object.latitude = @(restaurant.latitude.floatValue);
    object.longitude = @(restaurant.longitude.floatValue);
    object.createAt = [NSDate date];
    object.isVisited = @0;
    
    [[DataStore sharedDataStore] saveContext];
}

@end
