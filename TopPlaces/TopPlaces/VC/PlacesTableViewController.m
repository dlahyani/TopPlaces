// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesTableViewController.h"
#import "TopPlacesDetailsPhotoViewController.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN
@interface PlacesTableViewController() <UISplitViewControllerDelegate>

@end
@implementation PlacesTableViewController


- (void) viewDidLoad
{
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
  [self fetchPhotos];
  
}

// fetch photos from Flickr and set them in self.photos
- (IBAction)refreshTableCells
{
  [self fetchPhotos];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(__nullable id)sender
{
  NSLog(@"prepareForSegue");
  if ([segue.identifier isEqualToString:@"showDetailImage"]) {
    NSLog(@"prepareForSegue: show details");
    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
    TopPlacesDetailsPhotoViewController *dvc = (TopPlacesDetailsPhotoViewController *)  nvc.viewControllers[0];
    dvc.photoUrl = [FlickrFetcher URLforTopPlaces];
  }
  
}
#pragma mark - table view controller overrides

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlickrPhotoCell"];
  cell.textLabel.text = @"1asdasd";
  cell.detailTextLabel.text = @"hey";

  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected item at section: %@ row: %@", @(indexPath.section), @(indexPath.row));
  [self performSegueWithIdentifier:@"showDetailImage" sender:self];

}

#pragma mark - split view delegates
- (BOOL) splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
  return YES; //show master view by default
}

@end

NS_ASSUME_NONNULL_END
