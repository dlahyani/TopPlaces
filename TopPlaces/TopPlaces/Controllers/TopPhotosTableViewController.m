// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "TopPhotosTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopPhotosTableViewController ()

/// The task recieved from placesPhotosProvider, can be used to cancel the network activity
@property (strong, nonatomic) id<CancellableTask> downloadTask;

@end

@implementation TopPhotosTableViewController

#pragma mark -
#pragma mark UIViewController overrides
#pragma mark -

- (void)viewDidLoad {
  NSLog(@"TopPhotosTableViewController::viewDidLoad");
  [super viewDidLoad];
  [self.refreshControl addTarget:self
                          action:@selector(handleRefresh:)
                forControlEvents:UIControlEventValueChanged];

  [self fetchPhotos];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
  [self fetchPhotos];
}

- (void) dealloc {
  NSLog(@"TopPhotosTableViewController::dealloc");
  [self.downloadTask cancel];
}

#pragma mark -
#pragma mark PhotosTableViewController overrides
#pragma mark -

// fetch photos from Flickr from a certain place and set them in self.photos
- (void)fetchPhotos {
  NSLog(@"TopPhotosTableViewController::fetchPhotos");
  [self.refreshControl beginRefreshing];
  
  // WA for refreshControl not appearing
  self.tableView.contentOffset = CGPointMake(0, -CGRectGetHeight(self.refreshControl.frame));
  
  __weak TopPhotosTableViewController *weakSelf = self;
  //download the photos info
  self.downloadTask = [self.placesPhotosProvider
                       downloadPhotosInfoForPlace:self.placeInfo
                                   withMaxResults:50
                                   withCompletion:^(NSArray<id<PhotoInfo>> *photosInfo,
                                                    NSError *error) {
                                     // update UI
                                     [weakSelf.refreshControl endRefreshing];
                                     if (photosInfo && !error) {
                                       weakSelf.photosInfo = photosInfo;
                                       [weakSelf.tableView reloadData];
                                     }
                                   }];
}

@end

NS_ASSUME_NONNULL_END
