//
//  WikiCollectionViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 8/4/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiCollectionViewController.h"
#import "WikiAPIClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import "DataStore.h"
#import "WikiWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WikiCollectionViewController () <CLLocationManagerDelegate>

//@property (nonatomic, strong) NSArray *wikiArticles;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation WikiCollectionViewController

static NSString * const reuseIdentifier = @"WikiCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // https://developer.apple.com/library/ios/documentation/UIKit/Reference/UICollectionViewDelegateFlowLayout_protocol/
   
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
//    self.collectionViewLayout =
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.allowsMultipleSelection = NO; // only allow one selection for delegate method below
    
    self.dataStore = [DataStore sharedDataStore];
    
    self.locationManager = [CLLocationManager new];
    
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
}

- (void) updateWikiArticles {
    
    [SVProgressHUD showWithStatus:@"Updating POI"];
    
    //    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(40.7061682, -74.0136262);
    CLLocationCoordinate2D coordinates = self.dataStore.lastWikiUpdateLocation.coordinate;
    [WikiAPIClient getArticlesAroundLocation:coordinates radius:400 completion:^(NSArray *wikiArticles) {
        
        self.dataStore.wikiArticles = wikiArticles;
        
        [self.collectionView reloadData];
        
        [SVProgressHUD dismiss];
        
    }];
}

- (IBAction)doneButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
////#warning Incomplete method implementation -- Return the number of sections
//    return 1;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.dataStore.wikiArticles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    WikiArticle *currentArticle = self.dataStore.wikiArticles[indexPath.row];
    
    UILabel *label = (UILabel*)[cell viewWithTag:100];
    label.text = currentArticle.title;
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:99];
    
    imageView.clipsToBounds = YES;
//    imageView.image = [UIImage imageNamed:@"default-placeholder"];
    
    if (!currentArticle.image) {
        
        imageView.image = nil;
        
        [WikiAPIClient getArticleImageList:currentArticle.pageID completion:^(NSArray *imageList) {
            
            NSString *imageFileName = [imageList firstObject][@"title"];
            
            if (imageFileName) {
                [WikiAPIClient getArticleImageURL:imageFileName completion:^(NSURL *imageURL) {
                    
                    [imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (image)
                        {
                            imageView.alpha = 0.0;
                            
                            currentArticle.image = image;
                            
                            [UIView animateWithDuration:0.5 animations:^{
                                
                                imageView.alpha = 1.0;
                                
                            }];
                        }
                        
                        
                    }];
                    
                }];
            } else {
  
                NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=17&size=400x400&maptype=terrain&markers=color:red%%7C%f,%f", currentArticle.coordinate.latitude, currentArticle.coordinate.longitude,currentArticle.coordinate.latitude, currentArticle.coordinate.longitude];
                
                
//                NSLog(@"%@",urlString);
                NSURL *imageURL = [NSURL URLWithString: urlString];
                
                [imageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSLog(@"%@",error);
                    currentArticle.image = image;
                    
                }];
                
            }
            
            
        }];
        
    } else {
        
        imageView.image = currentArticle.image;
        
    }
    
    cell.layer.masksToBounds = NO;
//    cell.layer.cornerRadius = 8; // if you like rounded corners
    cell.layer.shadowOffset = CGSizeMake(1, 1);
//    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = 0.7;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - CLLocation Protocol Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = (CLLocation *)[locations firstObject];
    
    if (!self.dataStore.lastWikiUpdateLocation) {
        
        self.dataStore.lastWikiUpdateLocation = currentLocation;
        
        [self updateWikiArticles];
        
    } else {
        
        double distanceFromLastWikiUpdateLocation = [currentLocation distanceFromLocation:self.dataStore.lastWikiUpdateLocation];
        
        [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%fm away from last wiki update location", distanceFromLastWikiUpdateLocation]];
        
        if (distanceFromLastWikiUpdateLocation > 400) { // every quarter mile?
            
            self.dataStore.lastWikiUpdateLocation = currentLocation;
            
            [self updateWikiArticles];
            
        }
        
    }
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WikiWebViewController *destVC = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems firstObject];
    
    WikiArticle *selectedArticle = self.dataStore.wikiArticles[indexPath.row];
    
    destVC.wikiArticle = selectedArticle;
    
//    NSString *urlString = [NSString stringWithFormat:@"https://en.wikipedia.org/wiki/%@", [selectedArticle.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    
//    destVC.url = [NSURL URLWithString:urlString];
    
}

@end
