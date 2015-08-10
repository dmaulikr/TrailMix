//
//  FilterViewController.m
//  TrailMix
//
//  Created by Mason Macias on 8/6/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "FilterViewController.h"
#import <FAKFontAwesome.h>
#import <MultiSelectSegmentedControl.h>
@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *foodTypesTableView;
@property (strong, nonatomic) FAKFontAwesome *unFilledStarIcon;
@property (strong, nonatomic) FAKFontAwesome *filledStarIcon;
@property (strong, nonatomic) FAKFontAwesome *unSelectedDollarIcon;
@property (strong, nonatomic) FAKFontAwesome *selectedDollarIcon;
@property (weak, nonatomic) IBOutlet UIButton *starOne;
- (IBAction)starOneTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
- (IBAction)starTwoTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
- (IBAction)starThreeTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
- (IBAction)starFourTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *starFive;
- (IBAction)starFiveTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *fourDollar;
@property (weak, nonatomic) IBOutlet UIButton *threeDollar;
@property (weak, nonatomic) IBOutlet UIButton *twoDollar;
@property (weak, nonatomic) IBOutlet UIButton *oneDollar;
- (IBAction)fourDollarTapped:(id)sender;
- (IBAction)threeDollarTapped:(id)sender;
- (IBAction)twoDollarTapped:(id)sender;
- (IBAction)oneDollarTapped:(id)sender;
-(void)selectDollar:(UIButton *)button;
- (void)unSelectDollar:(UIButton *)button;
@end

@implementation FilterViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    //Setup star icons
    
    [self setUpStarIcons:self.starOne];
    [self setUpStarIcons:self.starTwo];
    [self setUpStarIcons:self.starThree];
    [self setUpStarIcons:self.starFour];
    [self setUpStarIcons:self.starFive];
    
    
    //Star Icons in selected state
    [self selectStarState:self.starOne];
    [self selectStarState:self.starTwo];
    [self selectStarState:self.starThree];
    [self selectStarState:self.starFour];
    [self selectStarState:self.starFive];
    
    //Setup Dollar Icons
    [self fourDollarSigns:self.fourDollar];
    [self threeDollarSigns:self.threeDollar];
    [self twoDollarSigns:self.twoDollar];
    [self oneDollarSign:self.oneDollar];

    self.foodTypesTableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
#pragma mark - Dollar Icon Setup and Logic
-(void)fourDollarSigns:(UIButton *)button
{
    self.selectedDollarIcon = [FAKFontAwesome dollarIconWithSize:30];
    [self.selectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor]];
    NSMutableAttributedString *fiveDollarString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.selectedDollarIcon attributedString]];
    [fiveDollarString appendAttributedString:[self.selectedDollarIcon attributedString]];
    [fiveDollarString appendAttributedString:[self.selectedDollarIcon attributedString]];
    [fiveDollarString appendAttributedString:[self.selectedDollarIcon attributedString]];
    [button setAttributedTitle:fiveDollarString forState:UIControlStateNormal];
}

-(void)threeDollarSigns:(UIButton *)button
{
    self.selectedDollarIcon = [FAKFontAwesome dollarIconWithSize:30];
    [self.selectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor]];
    NSMutableAttributedString *fiveDollarString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.selectedDollarIcon attributedString]];
    [fiveDollarString appendAttributedString:[self.selectedDollarIcon attributedString]];
    [fiveDollarString appendAttributedString:[self.selectedDollarIcon attributedString]];
    [button setAttributedTitle:fiveDollarString forState:UIControlStateNormal];
}

-(void)twoDollarSigns:(UIButton *)button
{
    self.selectedDollarIcon = [FAKFontAwesome dollarIconWithSize:30];
    [self.selectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor]];
    NSMutableAttributedString *fiveDollarString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.selectedDollarIcon attributedString]];
    [fiveDollarString appendAttributedString:[self.selectedDollarIcon attributedString]];
    [button setAttributedTitle:fiveDollarString forState:UIControlStateNormal];
}

-(void)oneDollarSign:(UIButton *)button
{
    self.selectedDollarIcon = [FAKFontAwesome dollarIconWithSize:30];
    [self.selectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor]];
    NSMutableAttributedString *fiveDollarString = [[NSMutableAttributedString alloc] initWithAttributedString:[self.selectedDollarIcon attributedString]];
    [button setAttributedTitle:fiveDollarString forState:UIControlStateNormal];
}

- (void)setUpDollarIcons:(UIButton *)button
{
    self.unSelectedDollarIcon = [FAKFontAwesome dollarIconWithSize:30];
    [self.unSelectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    self.selectedDollarIcon = [FAKFontAwesome dollarIconWithSize:30];
    [self.selectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor]];
    [button setAttributedTitle:[self.selectedDollarIcon attributedString] forState:UIControlStateNormal];
}
-(void)selectDollar:(UIButton *)button
{
    [button setAttributedTitle:[self.selectedDollarIcon attributedString] forState:UIControlStateNormal];
}
- (void)unSelectDollar:(UIButton *)button
{
           [button setAttributedTitle:[self.unSelectedDollarIcon attributedString] forState:UIControlStateNormal];
}
#pragma mark - Star Icon Setup and Logic

- (void)setUpStarIcons:(UIButton *)button
{
    self.unFilledStarIcon = [FAKFontAwesome starOIconWithSize:30];
    [self.unFilledStarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor]];
    [button setAttributedTitle:[self.filledStarIcon attributedString] forState:UIControlStateNormal];
    self.filledStarIcon = [FAKFontAwesome starIconWithSize:30];
    [self.filledStarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor]];
}

-(void)selectStarState:(UIButton *)button
{
            [button setAttributedTitle:[self.filledStarIcon attributedString] forState:UIControlStateNormal];
}

-(void)unselectStarState:(UIButton *)button
{
    [button setAttributedTitle:[self.unFilledStarIcon attributedString] forState:UIControlStateNormal];

}

- (NSAttributedString *)starState:(UIButton *)button
{
    return button.titleLabel.attributedText;
}

#pragma mark - Button Actions

- (IBAction)dismissButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)starOneTapped:(UIButton *)sender {
    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.filledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self unselectStarState:self.starTwo];
        [self unselectStarState:self.starThree];
        [self unselectStarState:self.starFour];
        [self unselectStarState:self.starFive];
    }
}
- (IBAction)starTwoTapped:(UIButton *)sender {
    
    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.filledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self selectStarState:self.starTwo];
        [self unselectStarState:self.starThree];
        [self unselectStarState:self.starFour];
        [self unselectStarState:self.starFive];
    }
    
        if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.unFilledStarIcon attributedString]]) {
            
            [self selectStarState:self.starOne];
            [self selectStarState:self.starTwo];
            [self unselectStarState:self.starThree];
            [self unselectStarState:self.starFour];
            [self unselectStarState:self.starFive];
    
            
        }

}
- (IBAction)starThreeTapped:(UIButton *)sender{
    
    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.filledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self selectStarState:self.starTwo];
        [self selectStarState:self.starThree];
        [self unselectStarState:self.starFour];
        [self unselectStarState:self.starFive];
    }
    
    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.unFilledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self selectStarState:self.starTwo];
        [self selectStarState:self.starThree];
        [self unselectStarState:self.starFour];
        [self unselectStarState:self.starFive];
        
        
    }

}
- (IBAction)starFourTapped:(UIButton *)sender {
    
    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.filledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self selectStarState:self.starTwo];
        [self selectStarState:self.starThree];
        [self selectStarState:self.starFour];
        [self unselectStarState:self.starFive];
    }
    
    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.unFilledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self selectStarState:self.starTwo];
        [self selectStarState:self.starThree];
        [self selectStarState:self.starFour];
        [self unselectStarState:self.starFive];
        
        
    }

}
- (IBAction)starFiveTapped:(UIButton *)sender {

    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.filledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self selectStarState:self.starTwo];
        [self selectStarState:self.starThree];
        [self selectStarState:self.starFour];
        [self selectStarState:self.starFive];
    }
    
    if ([sender.titleLabel.attributedText isEqualToAttributedString:[self.unFilledStarIcon attributedString]]) {
        
        [self selectStarState:self.starOne];
        [self selectStarState:self.starTwo];
        [self selectStarState:self.starThree];
        [self selectStarState:self.starFour];
        [self selectStarState:self.starFive];
        
        
    }

}

- (IBAction)fourDollarTapped:(UIButton *)sender {
    
}

- (IBAction)threeDollarTapped:(UIButton *)sender {
    
}

- (IBAction)twoDollarTapped:(id)sender {
}

- (IBAction)oneDollarTapped:(id)sender {
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
