// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "TopPhotosTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
@interface TopPhotosTableViewController ()
@property (strong, nonatomic) NSURLSessionTask *downloadTask;
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

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  NSLog(@"TopPhotosTableViewController::viewDidDisappear");
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
                       completionHandler:^(NSArray<id<PhotoInfo>> *photosInfo, NSError *error) {
                         // update UI
                         [weakSelf.refreshControl endRefreshing];
                         if (!photosInfo || error) {
                           return;
                         }
                         weakSelf.photosInfo = photosInfo;
                         [weakSelf.tableView reloadData];
                       }];
}

@end

NS_ASSUME_NONNULL_END
