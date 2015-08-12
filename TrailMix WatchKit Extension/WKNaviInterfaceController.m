//
//  WKNaviInterfaceController.m
//  TrailMix
//
//  Created by Cong Sun on 8/12/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "WKNaviInterfaceController.h"

@interface WKNaviInterfaceController ()
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *distanceLabel;
@property (strong, nonatomic)CLLocation *location;
@end

@implementation WKNaviInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    
    
    
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



