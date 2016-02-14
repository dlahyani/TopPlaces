// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesTableViewController.h"
#import "TopPhotosTableViewController.h"

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlacesTableViewController() <UISplitViewControllerDelegate>
@property (strong, nonatomic) NSDictionary *countryToPlacesMap;
@property (strong, nonatomic) NSArray<NSString*> *sortedContries;
@end
@implementation PlacesTableViewController

#pragma mark - UIViewController overrides
- (void) viewDidLoad {
  [super viewDidLoad];
  [self.refreshControl addTarget:self
                          action:@selector(handleRefresh:)
                forControlEvents:UIControlEventValueChanged];

  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  self.placesPhotosProvider = appDelegate.placesPhotosProvider;
  
  [self fetchPlaces]; //TODO: move this out to willappaer with once time flag for somethign
}


- (void)awakeFromNib {
  [super awakeFromNib];
  //this has to be done as early as possible
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;


}


#pragma mark - places getting and pre-processing logic
- (void) handleRefresh:(UIRefreshControl *)refreshControl {
  [self fetchPlaces];
}


- (void) fetchPlaces {
  [self.refreshControl beginRefreshing];
  
  //in background:
  __weak PlacesTableViewController *weakSelf = self;
  dispatch_queue_t fetchPhoto = dispatch_queue_create("flickr fetcher", NULL);
  dispatch_async(fetchPhoto, ^(void){
    
    NSArray<id<PlaceInfo>> *places = [weakSelf.placesPhotosProvider downloadPlaces];
    
    // convert the flat list to country->places map
    NSDictionary *placesMap = [PlacesTableViewController contriesMappingForPlacesArray:places];
    
    //sort the countries list
    NSArray *sortedCountries = [placesMap.allKeys sortedArrayUsingComparator:
        ^NSComparisonResult(id a, id b) {
            NSString *first = (NSString *)a;
            NSString *second = (NSString *)b;
            return [first compare:second];
      }];
    
    // update UI
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [weakSelf.refreshControl endRefreshing];
      weakSelf.countryToPlacesMap = placesMap;
      weakSelf.sortedContries = sortedCountries;
      [weakSelf.tableView reloadData];
    });
  });
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
    NSArray *sortedPlaces = [places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
      id<PlaceInfo> aPlace = (id<PlaceInfo>)a;
      id<PlaceInfo> bPlace = (id<PlaceInfo>)b;
      
      return [aPlace compare:bPlace];
    }];
    
    countryToPlacesMap[country] = sortedPlaces;
  }

  return countryToPlacesMap;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(__nullable id)sender {
  if ([segue.identifier isEqualToString:@"showPhotosOfPlace"]) {
    NSLog(@"prepareForSegue: showPhotosOfPlaces");
    
    TopPhotosTableViewController *tpvc =
        (TopPhotosTableViewController *)segue.destinationViewController;
    
    //get the selected cell row/section
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    //set the placeInfo for the incoming VC
    NSString *country = self.sortedContries[path.section];
    tpvc.placeInfo = self.countryToPlacesMap[country][path.row];
    
    //propagate the placePhotosProvider
    tpvc.placesPhotosProvider = self.placesPhotosProvider;
  }
}


#pragma mark - table view controller overrides
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.sortedContries count];
}


- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section {
  return self.sortedContries[section];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSString *country = self.sortedContries[section];
  return [self.countryToPlacesMap[country] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlickrPlacesCell"];
  
  NSString *country = self.sortedContries[indexPath.section];
  id<PlaceInfo> placeInfo = self.countryToPlacesMap[country][indexPath.row];
  cell.textLabel.text = placeInfo.title;
  cell.detailTextLabel.text = placeInfo.details;
  return cell;
}


#pragma mark - split view delegates
- (BOOL) splitViewController:(UISplitViewController *)splitViewController
    collapseSecondaryViewController:(UIViewController *)secondaryViewController
    ontoPrimaryViewController:(UIViewController *)primaryViewController {
  return YES; //show master view by default
}
@end

NS_ASSUME_NONNULL_END
