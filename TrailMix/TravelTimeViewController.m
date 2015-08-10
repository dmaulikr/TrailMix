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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
