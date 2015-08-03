//
//  WikiTableViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 8/3/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiTableViewController.h"
#import "WikiAPIClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
//#import <JDStatusBarNotification/JDStatusBarNotification.h>
//#import "DestinationDataStore.h"
#import "WikiWebViewController.h"
#import "DataStore.h"

@interface WikiTableViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) CLLocation *lastWikiUpdateLocation;
//@property (nonatomic, strong) DestinationDataStore *destinationDataStore;
@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation WikiTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.articleTitleLabel.adjustsFontSizeToFitWidth = YES;
    
//    self.destinationDataStore = [DestinationDataStore sharedDataStore];
    
    self.dataStore = [DataStore sharedDataStore];
    
    self.locationManager = [CLLocationManager new];
    
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
    
    
}
- (IBAction)doneButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) updateWikiArticles {
    
    [SVProgressHUD showWithStatus:@"Updating POI"];
    
    //    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(40.7061682, -74.0136262);
    CLLocationCoordinate2D coordinates = self.dataStore.lastWikiUpdateLocation.coordinate;
    [WikiAPIClient getArticlesAroundLocation:coordinates radius:400 completion:^(NSArray *wikiArticles) {
        
        self.dataStore.wikiArticles = wikiArticles;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    }];
}

#pragma mark - Table View Protocol Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataStore.wikiArticles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    
    WikiArticle *currentArticle = self.dataStore.wikiArticles[indexPath.row];
    
    cell.textLabel.text = currentArticle.title;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm",currentArticle.distance];
    
    
    return cell;
    
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

#pragma mark - CLLocation Protocol Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = (CLLocation *)[locations firstObject];
    
    if (!self.dataStore.lastWikiUpdateLocation) {
        
        self.dataStore.lastWikiUpdateLocation = currentLocation;
        
        [self updateWikiArticles];
        
    } else {
        
        double distanceFromLastWikiUpdateLocation = [currentLocation distanceFromLocation:self.dataStore.lastWikiUpdateLocation];
        
//        [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%fm away from last wiki update location", distanceFromLastWikiUpdateLocation]];
        
        if (distanceFromLastWikiUpdateLocation > 400) { // every quarter mile?
            
            self.dataStore.lastWikiUpdateLocation = currentLocation;
            
            [self updateWikiArticles];
            
        }
        
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WikiWebViewController *destVC = segue.destinationViewController;
    
    WikiArticle *selectedArticle = self.dataStore.wikiArticles[self.tableView.indexPathForSelectedRow.row];
    
    NSString *urlString = [NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@", [selectedArticle.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];

    destVC.url = [NSURL URLWithString:urlString];
    
}

@end
