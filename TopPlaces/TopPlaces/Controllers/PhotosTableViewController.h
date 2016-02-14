// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN
/// Abstract VC class for presenting a list of photos
@interface PhotosTableViewController : UITableViewController

/// abstract function that populates the photosInfo from some source.
- (void) fetchPhotos;

/// The list of photo's data in the Flickr format
/// To be read only once fetchPhotos was invoked.
@property (strong, nonatomic) NSArray<id<PhotoInfo>> *photosInfo;
@end

NS_ASSUME_NONNULL_END
