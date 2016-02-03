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

#pragma mark - UIViewController overrides
- (void) viewDidLoad
{
  [super viewDidLoad];
  [self.refreshControl addTarget:self
                          action:@selector(handleRefresh:)
                forControlEvents:UIControlEventValueChanged];
  
  [self fetchPlaces];
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


- (void) fetchPlaces
{
  [self.refreshControl beginRefreshing];
  NSURL *url = [FlickrFetcher URLforTopPlaces];
  
  //in background:
  dispatch_queue_t fetchPhoto = dispatch_queue_create("flickr fetcher", NULL);
  dispatch_async(fetchPhoto, ^(void){
    
    //download and convert places to array
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                        options:0
                                                                          error:NULL];
    
    NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
    
    // convert the flat list to country->places map
    NSDictionary *placesMap = [PlacesTableViewController contriesMappingForPlacesArray:places];
    
    //sort the countries list
    NSArray *sortedCountries = [placesMap.allKeys sortedArrayUsingComparator:
        ^NSComparisonResult(id a, id b) {
            NSString *first = (NSString*)a;
            NSString *second = (NSString*)b;
            return [first compare:second];
      }];
    
    // update UI
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [self.refreshControl endRefreshing];
      self.countryToPlacesMap = placesMap;
      self.sortedContries = sortedCountries;
      [self.tableView reloadData];
    });
  });

}


// convert the places list to the country->places map
+ (NSDictionary *)contriesMappingForPlacesArray:(NSArray*)places
{
  NSMutableDictionary *countryToPlacesMap = [[NSMutableDictionary alloc] init];
  for (NSDictionary *place in places) {
    NSArray *placesInfo =  [[place valueForKeyPath:FLICKR_PLACE_NAME]
                            componentsSeparatedByString:@", "];
    
    //country is the last part of the place name
    NSString *country = [placesInfo lastObject];
    
    //add the place under the corresponding country key
    
    if (![countryToPlacesMap objectForKey:country]) {
      countryToPlacesMap[country] = [[NSMutableArray alloc] init];
    }
    
    [countryToPlacesMap[country] addObject:place];
  }

  
  // sort places for each country
  for (NSString *country in countryToPlacesMap.allKeys) {
    NSArray *places = countryToPlacesMap[country];
    NSArray *sortedPlaces = [places sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
      NSDictionary *aDict =  (NSDictionary *)a;
      NSDictionary *bDict =  (NSDictionary *)b;
      NSString *aName =  [aDict valueForKeyPath:FLICKR_PLACE_NAME];
      NSString *bName =  [bDict valueForKeyPath:FLICKR_PLACE_NAME];
      return [aName compare:bName];
    }];
    
    countryToPlacesMap[country] = sortedPlaces;
  }

  return countryToPlacesMap;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(__nullable id)sender
{
  if ([segue.identifier isEqualToString:@"showPhotosOfPlace"]) {
    NSLog(@"prepareForSegue: showPhotosOfPlaces");
    
    TopPhotosTableViewController *tpvc =
        (TopPhotosTableViewController *)segue.destinationViewController;
    
    //get the selected cell row/section
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    
    //set the placeInfo for the incoming VC
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
  NSArray *placesInfo =  [[self.countryToPlacesMap[country][indexPath.row]
                                      valueForKeyPath:FLICKR_PLACE_NAME]
                          componentsSeparatedByString:@", "];
  
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
