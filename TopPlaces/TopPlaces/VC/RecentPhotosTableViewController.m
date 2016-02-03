// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "RecentPhotosTableViewController.h"
#import "PhotosHistory.h"
NS_ASSUME_NONNULL_BEGIN
@interface RecentPhotosTableViewController()  <UISplitViewControllerDelegate>

@end
@implementation RecentPhotosTableViewController

- (void) fetchPhotos
{
  self.photosInfo = [PhotosHistory historyArray];
  [self.tableView reloadData];
}

- (void) viewDidLoad
{
  [super viewDidLoad];
  self.splitViewController.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self fetchPhotos]; //history updates frequently so we want to udpate every time we show images
  NSLog(@"RecentPhotosTableViewController::viewWillAppear");
}

#pragma mark - split view delegates
- (BOOL) splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController
{
  return YES; //show master view by default
}


@end

NS_ASSUME_NONNULL_END
