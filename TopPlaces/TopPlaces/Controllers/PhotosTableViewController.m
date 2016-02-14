// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PhotosTableViewController.h"
#import "DetailsPhotoViewController.h"
#import "PlacesPhotosProvider.h"
NS_ASSUME_NONNULL_BEGIN
@interface PhotosTableViewController()

@end

@implementation PhotosTableViewController
#pragma mark - UIView overrides
- (void) viewDidLoad {
  [super viewDidLoad];
  
  [self fetchPhotos]; //TODO: need to move this as it being called for all tabs even if not shown
}

- (void) fetchPhotos {
  //abstract
  assert(0);
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if ([segue.identifier isEqualToString:@"showPhoto"]) {
    NSLog(@"prepareForSegue: showPhoto");
    UINavigationController *nvc = (UINavigationController *)segue.destinationViewController;
    DetailsPhotoViewController *dpvc = nvc.viewControllers[0];
    NSIndexPath *path = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    dpvc.photoInfo = self.photosInfo[path.row];
    dpvc.placesPhotosProvider = self.placesPhotosProvider;
  }
}


#pragma mark - UITableViewDataSource overrides
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.photosInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  UITableViewCell *cell;
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"FlickrPhotoCell"];
  id<PhotoInfo> photoInfo = self.photosInfo[indexPath.row];
  NSString *photoTitle =  photoInfo.title;
  NSString *photoDetails = photoInfo.details;
  

  cell.textLabel.text = photoTitle;
  cell.detailTextLabel.text = photoDetails;
  
  
  return cell;
}



@end

NS_ASSUME_NONNULL_END
