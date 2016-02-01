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
// fetch photos from Flickr from a certain place and set them in self.photos
- (IBAction) fetchPhotos
{
  [self.refreshControl beginRefreshing];
  dispatch_queue_t fetchPhoto = dispatch_queue_create("photos in place", NULL);
  dispatch_async(fetchPhoto, ^(void){
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:[self.placeInfo valueForKeyPath:FLICKR_PLACE_ID] maxResults:50];
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
    NSArray *photos = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [self.refreshControl endRefreshing];
      self.photosInfo = photos;
      [self.tableView reloadData];
    });
  });
  
}

@end

NS_ASSUME_NONNULL_END
