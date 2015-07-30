//
//  RestaurantPreferenceTableViewController.m
//  TrailMix
//
//  Created by Cong Sun on 7/30/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "RestaurantPreferenceTableViewController.h"
#import "YelpAPIClient.h"

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
    
    [YelpAPIClient getCuisineTypesAndRestaurantWithLatitude:self.currentLatitude Longitude:self.currentLongitude Radius:self.timeInMinute*83.1495 CompletionBlock:^(NSDictionary *cuisineDictionary) {
        self.restaurantDictionary = cuisineDictionary;
        [self.tableView reloadData];
        NSLog(@"finished!");
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

-(void)requestData{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section==0){
        return self.contentOfFoodTypeSection.count;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantCell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        cell.textLabel.text = self.contentOfFoodTypeSection[indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return @"Restaurant Type";
            break;
            
        default:
            return @"To Be Edited";
            break;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return UITableViewAutomaticDimension;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            //Food Type
            if([self.tableView numberOfRowsInSection:0]==1){//not expand yet
                NSArray *restaurantTypeArray = self.restaurantDictionary.allKeys;
                [self.contentOfFoodTypeSection addObjectsFromArray:restaurantTypeArray];
                NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }else{//already expand
                
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            break;

        default:
            break;
    }
    
    
    
    
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
