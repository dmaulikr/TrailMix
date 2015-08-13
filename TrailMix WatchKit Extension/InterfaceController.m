//
//  InterfaceController.m
//  TrailMix WatchKit Extension
//
//  Created by Cong Sun on 8/11/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "InterfaceController.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceButton *resumeButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *adventureButton;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"      New"];
//    NSTextAttachment *adventureAttachment = [[NSTextAttachment alloc]init];
//    adventureAttachment.image = [UIImage imageNamed:@"foodRound"];
//    NSLog(@"%@",adventureAttachment);
//    NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:adventureAttachment];
//    [string replaceCharactersInRange:NSMakeRange(4, 1) withAttributedString:attString];
//    
//    [self.adventureButton setAttributedTitle:string];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    if(![RestaurantCDObject getLatestRestaurant]){
        [self.resumeButton setEnabled:NO];
    }else{
        [self.resumeButton setEnabled:YES];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



