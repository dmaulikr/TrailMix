//
//  IntroAdventureViewController.m
//  TrailMix
//
//  Created by Mason Macias on 8/12/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "IntroAdventureViewController.h"

@interface IntroAdventureViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *adventureButtons;


@end

@implementation IntroAdventureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIButton *button in self.adventureButtons) {
        [self formatButton:button];
    }
}

-(void)formatButton:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    
}


@end
