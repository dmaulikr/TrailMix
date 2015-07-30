//
//  RestaurantPreferenceTableViewController.m
//  TrailMix
//
//  Created by Cong Sun on 7/30/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "RestaurantPreferenceTableViewController.h"
#import "YelpAPIClient.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface RestaurantPreferenceTableViewController ()
@property (strong, nonatomic) YelpAPIClient *yelpClient;
@property (strong, nonatomic) NSDictionary *restaurantDictionary;
@property (strong, nonatomic) NSMutableArray *contentOfFoodTypeSection;
@property (strong, nonatomic) NSMutableArray *selectedFoodTypeArray;
@end

@implementation RestaurantPreferenceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"minutes selected: %ld",self.timeInMinute);
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [YelpAPIClient getCuisineTypesAndRestaurantWithLatitude:self.currentLatitude Longitude:self.currentLongitude Radius:self.timeInMinute*83.1495 CompletionBlock:^(void) {
        NSLog(@"finished!");
        [SVProgressHUD dismiss];
    }];
    self.contentOfFoodTypeSection = [[NSMutableArray alloc]init];
    [self.contentOfFoodTypeSection addObject:@"Random(Default)"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
