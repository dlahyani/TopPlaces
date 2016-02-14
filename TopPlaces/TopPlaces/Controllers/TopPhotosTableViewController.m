// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "TopPhotosTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TopPhotosTableViewController

#pragma mark - UIView overrides

- (void) viewDidLoad {
  [super viewDidLoad];
  [self.refreshControl addTarget:self
                          action:@selector(handleRefresh:)
                forControlEvents:UIControlEventValueChanged];
}

- (void) handleRefresh:(UIRefreshControl *)refreshControl {
  [self fetchPhotos];
}



#pragma mark - PhotosTableViewController overrides
// fetch photos from Flickr from a certain place and set them in self.photos
- (void) fetchPhotos {
  [self.refreshControl beginRefreshing];
  
  // WA for refreshControl not appearing
  self.tableView.contentOffset = CGPointMake(0, -CGRectGetHeight(self.refreshControl.frame));
  
  // in background:
  __weak TopPhotosTableViewController *weakSelf = self;
  dispatch_queue_t fetchPhoto = dispatch_queue_create("photos in place", NULL);
  dispatch_async(fetchPhoto, ^(void){

    NSArray<id<PhotoInfo>> *photos = [weakSelf.placesPhotosProvider
                                          downloadPhotosInfoForPlace:weakSelf.placeInfo
                                                      withMaxResults:50];
    
    // update UI
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [weakSelf.refreshControl endRefreshing];
      weakSelf.photosInfo = photos;
      [weakSelf.tableView reloadData];
    });
  });
  
}

@end

NS_ASSUME_NONNULL_END
