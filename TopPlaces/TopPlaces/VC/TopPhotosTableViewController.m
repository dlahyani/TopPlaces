// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "TopPhotosTableViewController.h"

#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN

@implementation TopPhotosTableViewController
- (void) viewDidLoad
{
  [super viewDidLoad];
  [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void) handleRefresh:(UIRefreshControl *)refreshControl {
  [self fetchPhotos];
}
@end

NS_ASSUME_NONNULL_END
