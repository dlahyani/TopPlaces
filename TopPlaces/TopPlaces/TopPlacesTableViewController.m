// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "TopPlacesTableViewController.h"

#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN

@implementation TopPlacesTableViewController
- (void) viewDidLoad
{
  [super viewDidLoad];
  [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
}

- (void) handleRefresh:(UIRefreshControl *)refreshControl {
  [self fetchPhotos];
}

- (void) fetchPhotos
{
  [self.refreshControl beginRefreshing];
  NSURL *url = [FlickrFetcher URLforTopPlaces];
  dispatch_queue_t fetchPhoto = dispatch_queue_create("flickr fetcher", NULL);
  dispatch_async(fetchPhoto, ^(void){
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [self.refreshControl endRefreshing];
      self.photos = photos;
      [self.tableView reloadData];
    });
  });
  
 
}
@end

NS_ASSUME_NONNULL_END
