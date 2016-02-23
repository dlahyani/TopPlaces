// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesTableViewController.h"

#import "TopPhotosTableViewController.h"
#import "DetailsPhotoViewController.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlacesTableViewController() <UISplitViewControllerDelegate>

/// Map with country as key and associated places list as value
/// Used for presentation.
@property (strong, nonatomic) NSDictionary *countryToPlacesMap;

/// Sorted list of contries to present as sections
@property (strong, nonatomic) NSArray<NSString*> *sortedCountries;

/// The task recieved from placesPhotosProvider, can be used to cancel the network activity
@property (strong, nonatomic) id<CancellableTask> downloadTask;

@end

@implementation PlacesTableViewController

#pragma mark -
#pragma mark UIViewController overrides
#pragma mark -

- (void)viewDidLoad {
  NSLog(@"PlacesTableViewController viewDidLoad");
  [super viewDidLoad];
  [self.refreshControl addTarget:self
                          action:@selector(handleRefresh:)
                forControlEvents:UIControlEventValueChanged];

  //invoke initial fetch
  [self fetchPlaces];
}

- (void)awakeFromNib {
  NSLog(@"PlacesTableViewController awakeFromNib");
  [super awakeFromNib];
  
  // get the placesPhotosProvider for downloading places list
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  self.placesPhotosProvider = appDelegate.placesPhotosProvider;

  //this has to be done as early as possible
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
}

- (void) dealloc {
  NSLog(@"PlacesTableViewController::dealloc");
  [self.downloadTask cancel];
}

#pragma mark -
#pragma mark places getting and pre-processing logic
#pragma mark -

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
  [self fetchPlaces];
}

- (void)fetchPlaces {
  NSLog(@"PlacesTableViewController::fetchPlaces");
  [self.refreshControl beginRefreshing];
  __weak PlacesTableViewController *weakSelf = self;
  self.downloadTask =
      [self.placesPhotosProvider downloadPlacesWithCompletion:
            ^(NSArray<id<PlaceInfo>> *placesInfo, NSError *error) {
              [weakSelf.refreshControl endRefreshing];
              if (placesInfo && !error) {
                [weakSelf showPlaces:placesInfo];
              }
            }];
}

- (void) showPlaces:(NSArray<id<PlaceInfo>> *)placesInfo {
  // convert the flat list to country->places map
  NSDictionary *placesMap = [PlacesTableViewController
                             contriesMappingForPlacesArray:placesInfo];
  
  //sort the countries list
  NSArray *sortedCountries = [placesMap.allKeys sortedArrayUsingSelector:@selector(compare:)];
  
  // update UI:
  self.countryToPlacesMap = placesMap;
  self.sortedCountries = sortedCountries;
  [self.tableView reloadData];
}
// convert the places list to the country->places map
+ (NSDictionary *)contriesMappingForPlacesArray:(NSArray<id<PlaceInfo>> *)places {
  NSMutableDictionary *countryToPlacesMap = [[NSMutableDictionary alloc] init];
  for (id<PlaceInfo> place in places) {
    //add the place under the corresponding country key
    if (![countryToPlacesMap objectForKey:place.country]) {
      countryToPlacesMap[place.country] = [[NSMutableArray alloc] init];
    }
    
    [countryToPlacesMap[place.country] addObject:place];
  }
  
  // sort places for each country
  for (NSString *country in countryToPlacesMap.allKeys) {
    NSArray *places = countryToPlacesMap[country];
    NSArray *sortedPlaces = [places sortedArrayUsingSelector:@selector(compare:)];
    countryToPlacesMap[country] = sortedPlaces;
  }

  return countryToPlacesMap;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(__nullable id)sender {
  if ([segue.identifier isEqualToString:@"showPhotosOfPlace"]) {
    NSLog(@"prepareForSegue: showPhotosOfPlaces");
    
    TopPhotosTableViewController *tpvc =
        (TopPhotosTableViewController *)segue.destinationViewController;
    
    //get the selected cell row/section
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    //set the placeInfo for the incoming VC
    NSString *country = self.sortedCountries[path.section];
    tpvc.placeInfo = self.countryToPlacesMap[country][path.row];
    
    //propagate the placePhotosProvider
    tpvc.placesPhotosProvider = self.placesPhotosProvider;
  }
}

#pragma mark -
#pragma mark UITableViewDataSource
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.sortedCountries count];
}

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section {
  return self.sortedCountries[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSString *country = self.sortedCountries[section];
  return [self.countryToPlacesMap[country] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlickrPlacesCell"];
  
  NSString *country = self.sortedCountries[indexPath.section];
  id<PlaceInfo> placeInfo = self.countryToPlacesMap[country][indexPath.row];
  cell.textLabel.text = placeInfo.title;
  cell.detailTextLabel.text = placeInfo.details;
  return cell;
}

#pragma mark -
#pragma mark UISplitViewControllerDelegate
#pragma mark -

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
          collapseSecondaryViewController:(UIViewController *)secondaryViewController
                ontoPrimaryViewController:(UIViewController *)primaryViewController {
  //if details photo view controller has an image to show - show it and not the master view
  if ([secondaryViewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *navigationController = (UINavigationController *)secondaryViewController;
    if ([navigationController.childViewControllers[0] isKindOfClass:
            [DetailsPhotoViewController class]]) {
      DetailsPhotoViewController *detailsPhotoViewController =
            (DetailsPhotoViewController *)navigationController.childViewControllers[0];
      if (detailsPhotoViewController.photoInfo) {
        return NO;
      }
    }
  }
  return YES; //otherwise show the master view
}

@end

NS_ASSUME_NONNULL_END
