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
#import "DataStore.h"

@interface IntroAdventureViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *adventureButtons;

@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

@end

@implementation IntroAdventureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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


- (IBAction)resumeButtonTapped:(id)sender {
    UIViewController *destVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateInitialViewController];
    [DataStore sharedDataStore].destinationIsResaurant = YES;
    [self presentViewController:destVC animated:YES completion:nil];
}



@end
