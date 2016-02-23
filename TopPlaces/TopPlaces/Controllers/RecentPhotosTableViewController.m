// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "RecentPhotosTableViewController.h"

#import "PhotosHistory.h"
#import "PlacesPhotosProvider.h"
#import "DetailsPhotoViewController.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecentPhotosTableViewController()  <UISplitViewControllerDelegate>
@end

@implementation RecentPhotosTableViewController

#pragma mark -
#pragma mark UIView overrides
#pragma mark -

- (void)awakeFromNib {
  NSLog(@"RecentPhotosTableViewController::awakeFromNib");
  [super awakeFromNib];
  
  // get placePhotosProvider for downloading the images, there's no parent controller to provide it
  // so we do it here
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  self.placesPhotosProvider = appDelegate.placesPhotosProvider;

  // do this early so the splitViewController will talk to the delegate
  self.splitViewController.delegate = self;
  self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  //history updates frequently so we want to udpate every time we show images
  [self fetchPhotos];
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

#pragma mark -
#pragma mark PhotosTableViewController override
#pragma mark -

- (void)fetchPhotos {
  NSLog(@"RecentPhotosTableViewController::fetchPhotos");
  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  self.photosInfo = [appDelegate.photosHistory historyArray];
  [self.tableView reloadData];
}

@end

NS_ASSUME_NONNULL_END
