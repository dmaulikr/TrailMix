//
//  RestaurantCDObject+InitWithRestaurantObject.h
//  TrailMix
//
//  Created by Cong Sun on 7/31/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//
@class Restaurant;
#import "RestaurantCDObject.h"

@interface RestaurantCDObject (InitWithRestaurantObject)

-(void)initWithRestaurantObject:(Restaurant *)restaurant;

@end
