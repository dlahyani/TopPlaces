// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesTableViewController.h"
#import "TopPlacesDetailsPhotoViewController.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN

@interface PlacesTableViewController() <UISplitViewControllerDelegate>
@property (weak, nonatomic)  NSDictionary *selectedPhoto;
@end
@implementation PlacesTableViewController


- (void) viewDidLoad
{
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
  [self fetchPhotos];
  
}
- (void) fetchPhotos
{
  //no nothing - abstract
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(__nullable id)sender
{
  NSLog(@"prepareForSegue");
  if ([segue.identifier isEqualToString:@"showDetailImage"]) {
    NSLog(@"prepareForSegue: show details");
    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
    TopPlacesDetailsPhotoViewController *dvc = (TopPlacesDetailsPhotoViewController *)  nvc.viewControllers[0];
    dvc.photoUrl = [FlickrFetcher URLforPhoto:self.selectedPhoto format:FlickrPhotoFormatOriginal];
  }
  
}
#pragma mark - table view controller overrides

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlickrPhotoCell"];
  NSArray *placesInfo =  [[self.photos[indexPath.row] valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
  cell.textLabel.text = [placesInfo firstObject];
  cell.detailTextLabel.text = [placesInfo lastObject];

  return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected item at section: %@ row: %@", @(indexPath.section), @(indexPath.row));
  
  self.selectedPhoto = self.photos[indexPath.row];
  [self performSegueWithIdentifier:@"showDetailImage" sender:self];

}

#pragma mark - split view delegates
- (BOOL) splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
  return YES; //show master view by default
}

@end

NS_ASSUME_NONNULL_END
