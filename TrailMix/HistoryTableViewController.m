//
//  HistoryViewController.m
//  TrailMix
//
//  Created by Henry Chan on 8/13/15.
//  Copyright (c) 2015 Team Fax Machine. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "RestaurantCDObject+InitWithRestaurantObject.h"
#import "RestaurantDestinationWebViewController.h"

@interface HistoryTableViewController ()

@property (nonatomic, strong) NSArray *restauratHistory;

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.restauratHistory = [RestaurantCDObject getVisitHistory];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.restauratHistory.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    RestaurantCDObject *currentRestaurant = (RestaurantCDObject*)self.restauratHistory[indexPath.row];
    
    cell.textLabel.text = currentRestaurant.name;
    
    return cell;
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    RestaurantDestinationWebViewController *restaurantDestinationWebViewController = segue.destinationViewController;
    
    RestaurantCDObject *selectedRestaurant = (RestaurantCDObject*)self.restauratHistory[self.tableView.indexPathForSelectedRow.row];
    
    restaurantDestinationWebViewController.url = [NSURL URLWithString:selectedRestaurant.webUrl];
    
    restaurantDestinationWebViewController.locationName = selectedRestaurant.name;
    
}

@end
