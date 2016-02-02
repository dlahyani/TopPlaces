// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesTableViewController.h"
#import "TopPhotosTableViewController.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlacesTableViewController() <UISplitViewControllerDelegate>
@property (strong, nonatomic) NSDictionary *countryToPlacesMap;
@property (strong, nonatomic) NSArray<NSString*> *sortedContries;
@end
@implementation PlacesTableViewController


- (void) viewDidLoad
{
  [super viewDidLoad];
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
  [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
  [self fetchPlaces];
}



- (void) handleRefresh:(UIRefreshControl *)refreshControl {
  [self fetchPlaces];
}


- (void) fetchPlaces
{
  [self.refreshControl beginRefreshing];
  NSURL *url = [FlickrFetcher URLforTopPlaces];
  dispatch_queue_t fetchPhoto = dispatch_queue_create("flickr fetcher", NULL);
  dispatch_async(fetchPhoto, ^(void){
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
    
    NSDictionary *placesMap = [PlacesTableViewController contriesMappingForPlacesArray:places];
    
    NSArray *sortedCountries = [placesMap.allKeys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
      NSString *first = (NSString*)a;
      NSString *second = (NSString*)b;
      return [first compare:second];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [self.refreshControl endRefreshing];
      self.countryToPlacesMap = placesMap;
      self.sortedContries = sortedCountries;
      [self.tableView reloadData];
    });
  });
  
  
}

+ (NSDictionary *)contriesMappingForPlacesArray:(NSArray*)places
{
  NSMutableDictionary *countryToPlacesMap = [[NSMutableDictionary alloc] init];
  for (NSDictionary *place in places) {
    NSArray *placesInfo =  [[place valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    NSString *country = [placesInfo lastObject];
    if (![countryToPlacesMap objectForKey:country]) {
      countryToPlacesMap[country] = [[NSMutableArray alloc] init];
    }
    [countryToPlacesMap[country] addObject:place];
  }

  
  //TODO: sort places too
//  for (NSString *country in countryToPlacesMap.allKeys) {
//       countryToPlacesMap[country] = [[NSMutableArray alloc] init];
//  }

  return countryToPlacesMap;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(__nullable id)sender
{
  if ([segue.identifier isEqualToString:@"showPhotosOfPlace"]) {
    NSLog(@"prepareForSegue: showPhotosOfPlaces");
    TopPhotosTableViewController *tpvc = (TopPhotosTableViewController *)segue.destinationViewController;
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    NSString *country = self.sortedContries[path.section];
    tpvc.placeInfo = self.countryToPlacesMap[country][path.row];
  }
}

#pragma mark - table view controller overrides
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.sortedContries count];
}

- (NSString * __nullable)tableView:( UITableView * )tableView titleForHeaderInSection:(NSInteger)section
{
  return self.sortedContries[section];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSString *country = self.sortedContries[section];
  return [self.countryToPlacesMap[country] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlickrPlacesCell"];
  NSString *country = self.sortedContries[indexPath.section];
  NSArray *placesInfo =  [[self.countryToPlacesMap[country][indexPath.row] valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
  cell.textLabel.text = [placesInfo firstObject];
  NSString *details = @"-";
  if ([placesInfo count] >= 3) {
    //cut out the middle of the placesInfo array (all but the first and the last one)
    details = [[placesInfo subarrayWithRange:NSMakeRange(1, [placesInfo count] - 2)] componentsJoinedByString:@", "];
  }
  cell.detailTextLabel.text = details;
  return cell;
}


#pragma mark - split view delegates
- (BOOL) splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
  return YES; //show master view by default
}

@end

NS_ASSUME_NONNULL_END
