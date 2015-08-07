//
//  WikiCollectionViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 8/4/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiCollectionViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataStore.h"
#import "WikiWebViewController.h"
#import "WikiCollectionViewCell.h"

@interface WikiCollectionViewController ()

@property (nonatomic, strong) DataStore *dataStore;

@end

@implementation WikiCollectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
//    self.collectionViewLayout =
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.allowsMultipleSelection = NO; // only allow one selection for delegate method below
    
    self.dataStore = [DataStore sharedDataStore];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self selector:@selector(startedGettingArticlesAroundLocation) name:@"startedGettingArticlesAroundLocation" object:nil];
    
    [notificationCenter addObserver:self selector:@selector(finishedGettingArticlesAroundLocation) name:@"finishedGettingArticlesAroundLocation" object:nil];
    
}

- (void) startedGettingArticlesAroundLocation {

    [SVProgressHUD showWithStatus:@"Updating POI"];
    
}

- (void) finishedGettingArticlesAroundLocation {
 
    [self.collectionView reloadData];
    
    [SVProgressHUD dismiss];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [self viewDidDisappear:animated];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self name:@"startedGettingArticlesAroundLocation" object:nil];
    
    [notificationCenter removeObserver:self name:@"finishedGettingArticlesAroundLocation" object:nil];
    
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

- (WikiCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WikiCollectionViewCell *cell = (WikiCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"WikiCell" forIndexPath:indexPath];
    
    // Configure the cell
    
    WikiArticle *currentArticle = self.dataStore.wikiArticles[indexPath.row];
    
    cell.article = currentArticle;
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    WikiWebViewController *destVC = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems firstObject];
    
    WikiArticle *selectedArticle = self.dataStore.wikiArticles[indexPath.row];
    
    destVC.wikiArticle = selectedArticle;
    
}

@end
