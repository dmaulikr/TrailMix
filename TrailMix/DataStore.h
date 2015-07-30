//
//  DataStore.h
//  TrailMix
//
//  Created by Cong Sun on 7/30/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataStore : NSObject

+(instancetype) sharedDataStore;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *selectedFoodType;
@property (strong, nonatomic) NSMutableDictionary *restaurantDictionary;
-(void)saveContext;


@end
