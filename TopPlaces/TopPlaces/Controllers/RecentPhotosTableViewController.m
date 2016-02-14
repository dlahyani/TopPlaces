// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "RecentPhotosTableViewController.h"

#import "PhotosHistory.h"
#import "PlacesPhotosProvider.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN
@interface RecentPhotosTableViewController()  <UISplitViewControllerDelegate>

@end
@implementation RecentPhotosTableViewController

#pragma mark - UIView overrides
- (void) awakeFromNib {
  [super awakeFromNib];
  // do this early so the splitViewController will talk to the delegate
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
}



- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  //TODO: find a proper place for this
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  self.placesPhotosProvider = appDelegate.placesPhotosProvider;
  
  
  //history updates frequently so we want to udpate every time we show images
  [self fetchPhotos];
}


#pragma mark - split view delegates
- (BOOL) splitViewController:(UISplitViewController *)splitViewController
    collapseSecondaryViewController:(UIViewController *)secondaryViewController
          ontoPrimaryViewController:(UIViewController *)primaryViewController {
  return YES; //show master view by default
}


#pragma mark - PhotosTableViewController override

- (void) fetchPhotos {
  self.photosInfo = [PhotosHistory historyArray];
  [self.tableView reloadData];
}


@end

NS_ASSUME_NONNULL_END
