// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "RecentPhotosTableViewController.h"
#import "PhotosHistory.h"
NS_ASSUME_NONNULL_BEGIN

@implementation RecentPhotosTableViewController

- (void) fetchPhotos
{
  self.photosInfo = [PhotosHistory historyArray];
  [self.tableView reloadData];
}

@end

NS_ASSUME_NONNULL_END
