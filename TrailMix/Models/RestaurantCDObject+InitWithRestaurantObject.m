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

+(void)initWithRestaurantObject:(Restaurant *)restaurant{
    
    RestaurantCDObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"RestaurantCDObject" inManagedObjectContext:[DataStore sharedDataStore].managedObjectContext];
    
//    NSLog(@"restaurant Name saved = %@",restaurant.name);
//  
//    object.name = restaurant.name;
    object.latitude = @(restaurant.latitude.floatValue);
    NSLog(@"latitude = %@",object.latitude);
    object.longitude = @(restaurant.longitude.floatValue);
    NSLog(@"longitude = %@",object.longitude);
    object.name = restaurant.name;
    object.createAt = [NSDate date];
    object.isVisited = @0;
    object.venueId = restaurant.venueId;
    object.webUrl = restaurant.webLink;
    
    [[DataStore sharedDataStore] saveContext];
}

+(RestaurantCDObject *)getLatestRestaurant{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RestaurantCDObject"];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"createAt" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isVisited == NO"];
    request.predicate = predicate;
    request.sortDescriptors = @[descriptor];
    
    NSArray *resultArray = [[DataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
    
    for(RestaurantCDObject *object in resultArray){
        NSLog(@"Name = %@",object.name);
    }
    
    if(resultArray.count){
        return (RestaurantCDObject *)resultArray[0];
    }else{
        return nil;
    }
    
    
}
+(NSArray *)getVisitHistory{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"RestaurantCDObject"];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:@"createAt" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isVisited == YES"];
    request.predicate = predicate;
    request.sortDescriptors = @[descriptor];
    
    NSArray *resultArray = [[DataStore sharedDataStore].managedObjectContext executeFetchRequest:request error:nil];
    
    for(RestaurantCDObject *object in resultArray){
        NSLog(@"Name = %@",object.name);
    }
    
    return resultArray;
    
}

@end
