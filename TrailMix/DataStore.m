//
//  DataStore.m
//  TrailMix
//
//  Created by Cong Sun on 7/30/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "DataStore.h"
#import "Restaurant.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"

@interface DataStore()


@end


@implementation DataStore


+(instancetype)sharedDataStore{
    
    static DataStore *_sharedDataStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[DataStore alloc]init];
//        _sharedDataStore.selectedFoodTypes = [[NSMutableArray alloc] init];
    });
    
    return _sharedDataStore;
}

-(void)filteredRestaurant{
    NSMutableArray *resultRestaurantArray = [[NSMutableArray alloc]init];
    NSArray *tempArray;
    if(!self.selectedFoodTypes.count){
        tempArray = self.restaurantDictionary.allKeys;
    }else{
        tempArray = self.selectedFoodTypes;
    }
    
    
    for(NSString *restType in tempArray){
        NSArray *restaurantsOfType = self.restaurantDictionary[restType];
        for(Restaurant *restaurant in restaurantsOfType){
            NSNumber *dollarPref = restaurant.dollarSigns;
            NSNumber *starPref = restaurant.rating;
            if(dollarPref.integerValue<=[DataStore sharedDataStore].dollarPref){
                if(starPref.integerValue>=[DataStore sharedDataStore].starPref){
                    [resultRestaurantArray addObject:restaurant];
                }
            }
        }
    }
    
    NSInteger randomIndex = arc4random_uniform((u_int32_t)resultRestaurantArray.count);
    Restaurant *selectedRestaurant = resultRestaurantArray[randomIndex];
    self.selectedRestaurant = selectedRestaurant;
    [RestaurantCDObject initWithRestaurantObject:selectedRestaurant];

}

-(NSArray *)filteredRestaurantArray{
    NSMutableArray *allKeyArray = [[NSMutableArray alloc]initWithArray:self.restaurantDictionary.allKeys];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:nil ascending:YES];
    [allKeyArray sortUsingDescriptors:@[descriptor]];
    NSMutableArray* foodTypeArray = [[NSMutableArray alloc]init];
    
    for(NSString *foodType in allKeyArray){
        BOOL hasValidRestaurant = NO;
        NSArray *restaurantArray = [DataStore sharedDataStore].restaurantDictionary[foodType];
        for(Restaurant *restaurant in restaurantArray){
            NSNumber *dollarPref = restaurant.dollarSigns;
            NSNumber *starPref = restaurant.rating;
            if(dollarPref.integerValue<=[DataStore sharedDataStore].dollarPref){
                if(starPref.integerValue>=[DataStore sharedDataStore].starPref){
                    hasValidRestaurant = YES;
                }
            }
        }
        if(hasValidRestaurant){
            [foodTypeArray addObject:foodType];
        }
    }
    self.selectedFoodTypes = foodTypeArray;
    return foodTypeArray;
}



-(NSMutableArray *)selectedFoodTypes{
    if(!_selectedFoodTypes){
        NSLog(@"FIRST TIME INIT %@",self.restaurantDictionary);
        _selectedFoodTypes = [[NSMutableArray alloc]init];
    }
    return _selectedFoodTypes;
}

-(NSMutableDictionary *)restaurantDictionary{
    if(!_restaurantDictionary){
        _restaurantDictionary = [[NSMutableDictionary alloc]init];
    }
    return _restaurantDictionary;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
@synthesize managedObjectContext = _managedObjectContext;
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }


    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TrainMix.sqlite"];

    NSError *error = nil;

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TrailMix" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
