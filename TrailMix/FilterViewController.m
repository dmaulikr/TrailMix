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
#import "NaviViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FourSquareAPIClient.h"
#import "DataStore.h"

@interface FilterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *foodTypesTableView;
@property (strong, nonatomic) FAKFontAwesome *unFilledStarIcon;
@property (strong, nonatomic) FAKFontAwesome *filledStarIcon;
@property (strong, nonatomic) FAKFontAwesome *unSelectedDollarIcon;
@property (strong, nonatomic) FAKFontAwesome *selectedDollarIcon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starButtons;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dollarButtons;

@property (strong, nonatomic) NSArray *foodTypes;
@property (strong, nonatomic) NSMutableArray *selectedFoodTypes;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end

@implementation FilterViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    NSLog(@"will appear filter view");
    [[DataStore sharedDataStore] addObserver:self forKeyPath:@"selectedFoodTypes" options:NSKeyValueObservingOptionNew context:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
           NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]initWithKey:nil ascending:YES];
        self.foodTypes = [[DataStore sharedDataStore].restaurantDictionary.allKeys sortedArrayUsingDescriptors:@[descriptor]];
        self.selectedFoodTypes = [DataStore sharedDataStore].selectedFoodTypes;
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.foodTypesTableView.backgroundColor = [UIColor clearColor];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    NSLog(@"monitored");
    
    if(object == [DataStore sharedDataStore]){
        NSLog(@"changed!!!");
        
        NSArray *newFoodTypes = change[NSKeyValueChangeNewKey];
        NSLog(@"%@",newFoodTypes);
        if(newFoodTypes.count){
            self.startButton.enabled = YES;
        }else{
            self.startButton.enabled = NO;
        }
    }
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tableView.tintColor = [UIColor whiteColor];

    
    //Setup icons
    [self initTheStars];
    [self initTheDollars];
    [self setupBackButton];
    
    //Star Icons in selected state
    NSUInteger starPref = [self.userDefaults integerForKey:@"starPref"];
    NSUInteger dollarPref = [self.userDefaults integerForKey:@"pricingPref"];
    [self updateStarPrefWithTagNum:starPref];
    [self updateDollarPreWithTagNum:dollarPref];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)dealloc {
    NSLog(@"will disappear filter view");
    [[DataStore sharedDataStore] removeObserver:self forKeyPath:@"selectedFoodTypes"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupBackButton
{
    FAKFontAwesome *backIcon = [FAKFontAwesome angleLeftIconWithSize:40];
    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [self.backButton setAttributedTitle:[backIcon attributedString] forState:UIControlStateNormal];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.foodTypes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodTypeCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.foodTypes[indexPath.row];
    BOOL isSelected = NO;
    for(NSString *string in self.selectedFoodTypes){
        if ([self.foodTypes[indexPath.row] isEqualToString:string]) {
            isSelected = YES;
        }
    }
    if(isSelected){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedFoodTypes addObject: self.foodTypes[indexPath.row]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedFoodTypes removeObject:self.foodTypes[indexPath.row]];
    }
    
}


-(void)initTheStars
{
    for(UIButton *button in self.starButtons){
        [self setUpStarIcons:button];
    }
}

-(void)updateStarPrefWithTagNum:(NSInteger)tag{
    for(UIButton *button in self.starButtons){
        [self.userDefaults setInteger:tag forKey:@"starPref"];
        if (button.tag <= tag) {
            [self selectStarState:button];
        }else{
            [self unselectStarState:button];
        }
    }
    
}



#pragma mark - Dollar Icon Setup and Logic

-(void)initTheDollars
{
    self.selectedDollarIcon = [FAKFontAwesome dollarIconWithSize:20];
    [self.selectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    self.unSelectedDollarIcon = [FAKFontAwesome dollarIconWithSize:20];
    [self.unSelectedDollarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]];
    
    for (UIButton *button in self.dollarButtons) {
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:[self.selectedDollarIcon attributedString]];
        for(NSInteger i = 0; i<button.tag;i++){
            [string appendAttributedString:[self.selectedDollarIcon attributedString]];
        }
        [button setAttributedTitle:string forState:UIControlStateNormal];
    }
}

-(void)selectDollar:(UIButton *)button
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:[self.selectedDollarIcon attributedString]];
    for(NSInteger i = 0; i < button.tag; i++){
        [string appendAttributedString:[self.selectedDollarIcon attributedString]];
    }
    [button setAttributedTitle:string forState:UIControlStateNormal];
}
- (void)unSelectDollar:(UIButton *)button
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:[self.unSelectedDollarIcon attributedString]];
    for(NSInteger i = 0; i < button.tag; i++){
        [string appendAttributedString:[self.unSelectedDollarIcon attributedString]];
    }
    [button setAttributedTitle:string forState:UIControlStateNormal];
}

-(void)updateDollarPreWithTagNum:(NSInteger)tag
{
    
    for (UIButton *button in self.dollarButtons) {
        if (button.tag > tag) {
            [self unSelectDollar:button];
        } else {
            [self selectDollar:button];
        }
    }
}

#pragma mark - Star Icon Setup and Logic

- (void)setUpStarIcons:(UIButton *)button
{
    self.unFilledStarIcon = [FAKFontAwesome starOIconWithSize:25];
    [self.unFilledStarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [button setAttributedTitle:[self.filledStarIcon attributedString] forState:UIControlStateNormal];
    self.filledStarIcon = [FAKFontAwesome starIconWithSize:25];
    [self.filledStarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
}

-(void)selectStarState:(UIButton *)button
{
            [button setAttributedTitle:[self.filledStarIcon attributedString] forState:UIControlStateNormal];
}

-(void)unselectStarState:(UIButton *)button
{
    [button setAttributedTitle:[self.unFilledStarIcon attributedString] forState:UIControlStateNormal];
}

#pragma mark - Button Actions

- (IBAction)dismissButtonTapped:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)starButtonTapped:(UIButton *)sender
{
    [DataStore sharedDataStore].starPref = sender.tag;
    [self updateStarPrefWithTagNum:sender.tag];
    self.foodTypes = [[DataStore sharedDataStore] filteredRestaurantArray];
    [self.tableView reloadData];
}

- (IBAction)dollarButtontapped:(UIButton *)sender
{
    [DataStore sharedDataStore].dollarPref = sender.tag;
    [self updateDollarPreWithTagNum:sender.tag];
    self.foodTypes = [[DataStore sharedDataStore] filteredRestaurantArray];
    [self.tableView reloadData];
}

- (IBAction)goButtonTapped:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NaviViewController *destVC = [storyboard instantiateInitialViewController];
    [[DataStore sharedDataStore] filteredRestaurant];
    [DataStore sharedDataStore].destinationIsResaurant = YES;
    [self presentViewController:destVC animated:YES completion:nil];
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
