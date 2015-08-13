//
//  IntroAdventureViewController.m
//  TrailMix
//
//  Created by Mason Macias on 8/12/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "IntroAdventureViewController.h"
#import "NaviViewController.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"

@interface IntroAdventureViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *adventureButtons;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@end

@implementation IntroAdventureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UIButton *button in self.adventureButtons) {
//        [self formatButton:button];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(![RestaurantCDObject getLatestRestaurant]){
        self.resumeButton.enabled = NO;
        [self.resumeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.resumeButton.layer.borderColor = [UIColor grayColor].CGColor;
    }else{
        self.resumeButton.enabled = YES;
        [self.resumeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.resumeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)formatButton:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    
}

- (IBAction)resumeButtonTapped:(id)sender {
    UIViewController *destVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    [self presentViewController:destVC animated:YES completion:nil];
}



@end
