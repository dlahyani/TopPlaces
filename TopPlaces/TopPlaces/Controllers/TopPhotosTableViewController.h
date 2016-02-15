// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PhotosTableViewController.h"

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN
/// VC for presenting a list of photos related to some specific place
@interface TopPhotosTableViewController : PhotosTableViewController

/// The place info where from to get the list of the photos
@property (strong, nonatomic) id<PlaceInfo> placeInfo;

@end

NS_ASSUME_NONNULL_END
