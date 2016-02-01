// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesTableViewController.h"
#import "TopPhotosTableViewController.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlacesTableViewController() <UISplitViewControllerDelegate>
@property (strong, nonatomic) NSArray *places;
@end
@implementation PlacesTableViewController


- (void) viewDidLoad
{
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
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
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [self.refreshControl endRefreshing];
      self.places = places;
      [self.tableView reloadData];
    });
  });
  
  
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(__nullable id)sender
{
  NSLog(@"prepareForSegue");
  if ([segue.identifier isEqualToString:@"showPhotosOfPlace"]) {
    NSLog(@"prepareForSegue: showPhotosOfPlaces");
    TopPhotosTableViewController *tpvc = (TopPhotosTableViewController *)segue.destinationViewController;
    tpvc.placeInfo = self.places[((UITableViewCell *)sender).tag];

  } else if ([segue.identifier isEqualToString:@"showDetailImage"]) {
    NSLog(@"prepareForSegue: show details");
//    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
//    TopPlacesDetailsPhotoViewController *dvc = (TopPlacesDetailsPhotoViewController *)  nvc.viewControllers[0];
//    dvc.photoUrl = [FlickrFetcher URLforPhoto:self.selectedPhoto format:FlickrPhotoFormatOriginal];
  }
}

#pragma mark - table view controller overrides

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.places count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlickrPhotoCell"];
  NSArray *placesInfo =  [[self.places[indexPath.row] valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
  cell.textLabel.text = [placesInfo firstObject];
  cell.detailTextLabel.text = [placesInfo lastObject];
  cell.tag = indexPath.row;
  return cell;
}

//
//- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  NSLog(@"selected item at section: %@ row: %@", @(indexPath.section), @(indexPath.row));
//  
//  self.selectedPhoto = self.photos[indexPath.row];
//  TopPlacesDetailsPhotoViewController *dvc = [[TopPlacesDetailsPhotoViewController alloc] init];
//  dvc.photoUrl = [FlickrFetcher URLforPhoto:self.selectedPhoto format:FlickrPhotoFormatOriginal];
//  [self.splitViewController showDetailViewController:dvc sender:self];
//
//}

#pragma mark - split view delegates
- (BOOL) splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
  return YES; //show master view by default
}

@end

NS_ASSUME_NONNULL_END
