//
//  TravelTimeViewController.m
//  TrailMix
//
//  Created by Mason Macias on 8/5/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "TravelTimeViewController.h"

@interface TravelTimeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *fiveMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *tenMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *twentyMinuteButton;
@property (weak, nonatomic) IBOutlet UIButton *thirtyMinuteButton;
@property (assign, nonatomic) NSInteger selectedTime;

@end

@implementation TravelTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *buttons = @[self.fiveMinuteButton, self.tenMinuteButton, self.twentyMinuteButton, self.thirtyMinuteButton];
    for (UIButton *button in buttons)
    {
        [self formatTimeButton:button];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)formatTimeButton:(UIButton *)button
{
    button.backgroundColor = [UIColor clearColor];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (IBAction)timeButtonTapped:(id)sender {
    UIButton *button = sender;
    self.selectedTime = button.tag;
    [self performSegueWithIdentifier:@"goToCompass" sender:nil];
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
