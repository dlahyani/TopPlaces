// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrPlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN

/// VC for presenting a list of top Flickr places
@interface PlacesTableViewController : UITableViewController


///TODO:
@property (strong, nonatomic) id<PlacesPhotosProvider> placesPhotosProvider;
@end

NS_ASSUME_NONNULL_END
