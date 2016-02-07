// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PhotosTableViewController.h"


NS_ASSUME_NONNULL_BEGIN
/// VC for presenting a list of photos related to some specific place
@interface TopPhotosTableViewController : PhotosTableViewController

/// The The Flickr place dict where from to get the list of the photos
@property (strong, nonatomic) NSDictionary *placeInfo;
@end

NS_ASSUME_NONNULL_END
