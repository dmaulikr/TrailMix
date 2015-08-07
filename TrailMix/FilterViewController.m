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
@interface FilterViewController ()<MultiSelectSegmentedControlDelegate>
@property (weak, nonatomic) IBOutlet UITableView *foodTypesTableView;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *dollarSignSegmentControl;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;
@property (strong, nonatomic) FAKFontAwesome *unFilledStarIcon;
@property (strong, nonatomic) FAKFontAwesome *filledStarIcon;
- (IBAction)starButtonTapped:(UIButton *)sender;




@end

@implementation FilterViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.dollarSignSegmentControl.delegate = self;
    for (UIButton *star in self.starButtons)
    {
        [self setUpStarIcons:star];
        
    }
    
    self.foodTypesTableView.backgroundColor = [UIColor clearColor];
    
    UIFont *helveticaNeue = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    NSDictionary *attributes = @{NSFontAttributeName:helveticaNeue};
    [self.dollarSignSegmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
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

-(void)multiSelect:(MultiSelectSegmentedControl *)multiSelectSegmentedControl didChangeValue:(BOOL)selected atIndex:(NSUInteger)index {
    
    if (selected) {
        NSLog(@"multiSelect with tag %lu selected button at index: %lu", multiSelectSegmentedControl.tag, index);
    } else {
        NSLog(@"multiSelect with tag %lu deselected button at index: %lu", multiSelectSegmentedControl.tag, index);
    }
    
    NSLog(@"%@", multiSelectSegmentedControl.selectedSegmentIndexes);
    
}

#pragma mark - Star Icon Setup and Logic

- (void)setUpStarIcons:(UIButton *)button
{
    self.unFilledStarIcon = [FAKFontAwesome starOIconWithSize:30];
    [self.unFilledStarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [button setAttributedTitle:[self.unFilledStarIcon attributedString] forState:UIControlStateNormal];
    self.filledStarIcon = [FAKFontAwesome starIconWithSize:30];
    [self.filledStarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
}

-(void)changeStarState:(UIButton *)button
{
    if ([button.titleLabel.attributedText isEqualToAttributedString:[self.unFilledStarIcon attributedString]]) {
        
        [button setAttributedTitle:[self.filledStarIcon attributedString] forState:UIControlStateNormal];
    }
    
    if ([button.titleLabel.attributedText isEqualToAttributedString:[self.filledStarIcon attributedString]]) {
        
        [button setAttributedTitle:[self.unFilledStarIcon attributedString] forState:UIControlStateNormal];
    }
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

- (IBAction)starButtonTapped:(UIButton *)sender
{
    [self changeStarState:sender];
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
