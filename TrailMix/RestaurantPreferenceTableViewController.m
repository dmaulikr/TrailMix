//
//  RestaurantPreferenceTableViewController.m
//  TrailMix
//
//  Created by Cong Sun on 7/30/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//
@import TrailMixFramework;

#import "RestaurantPreferenceTableViewController.h"
#import "FourSquareAPIClient.h"
#import "DataStore.h"
#import "YelpAPIClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Restaurant.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"


@interface RestaurantPreferenceTableViewController ()
@property (strong, nonatomic) YelpAPIClient *yelpClient;
@property (strong, nonatomic) NSDictionary *restaurantDictionary;
@property (strong, nonatomic) NSMutableArray *contentOfFoodTypeSection;
@property (strong, nonatomic) NSMutableArray *selectedFoodTypeArray;
@property (weak, nonatomic) IBOutlet UITableViewCell *restaurantTypeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *priceCell;
@end

@implementation RestaurantPreferenceTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"minutes selected: %ld",self.timeInMinute);
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [FourSquareAPIClient getNearbyRestaurantWithLatitude:self.currentLatitude Longitude:self.currentLongitude Radius:self.timeInMinute*83.1495 CompletionBlock:^() {
        NSLog(@"finished");
        [self updateUI];
        [SVProgressHUD dismiss];
    }];
//    self.contentOfFoodTypeSection = [[NSMutableArray alloc]init];
//    [self.contentOfFoodTypeSection addObject:@"Random(Default)"];
//    self.restaurantDictionary = [DataStore sharedDataStore].restaurantDictionary;
//    self.selectedFoodTypeArray = [DataStore sharedDataStore].selectedFoodTypes;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateUI];
}

-(void)updateUI{
    //update restaurant type
    
    NSLog(@"%@",[DataStore sharedDataStore].selectedFoodTypes);
    
    if([DataStore sharedDataStore].selectedFoodTypes.count<[DataStore sharedDataStore].restaurantDictionary.allKeys.count){
        NSString *string = [NSString stringWithFormat:@"%lu",[DataStore sharedDataStore].selectedFoodTypes.count];
        self.restaurantTypeCell.textLabel.text = string;

        
    }else{
        self.restaurantTypeCell.textLabel.text = @"Random";
    }
    
    //update Price
//    BOOL hasSelectedPriceLogic = NO;
//    NSMutableString *titleString = [[NSMutableString alloc]init];
//    for(NSInteger i = 0 ;i <[DataStore sharedDataStore].selectedDollarSign.count; i++){
//        if(((NSNumber *)[DataStore sharedDataStore].selectedDollarSign[i]).integerValue){
//            hasSelectedPriceLogic = YES;
//            [titleString appendString:[NSString stringWithFormat:@"%@  ",[self returnDollarSignWithNumber:i]]];
//        }
//    }
//    if(hasSelectedPriceLogic){
//        self.priceCell.textLabel.text = titleString;
//    }else{
//        self.priceCell.textLabel.text = @"Random";
//    }
}


-(NSString *)returnDollarSignWithNumber:(NSInteger)count{
    NSMutableString *string = [[NSMutableString alloc]initWithString:@"$"];
    for(NSInteger i = 0; i < count; i++){
        [string appendString:@"$"];
    }
    return string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonTapped:(id)sender {
    [[DataStore sharedDataStore] filteredRestaurant];
    [DataStore sharedDataStore].destinationIsResaurant = YES;
    [self performSegueWithIdentifier:@"goToCompass" sender:nil];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
