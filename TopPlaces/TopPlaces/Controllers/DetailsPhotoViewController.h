// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN
/// VC for presenting a photo given the photo data in Flickr format.
@interface DetailsPhotoViewController : UIViewController

/// The photo data we want to present the image of.
/// Should be set before segueing to this VC in prepareForSegue
@property (strong, nonatomic) id<PhotoInfo> photoInfo;

/// The data source we use to download the photo
/// Should be set before segueing to this VC in prepareForSegue
@property (strong, nonatomic) id<PlacesPhotosProvider> placesPhotosProvider;

@end

NS_ASSUME_NONNULL_END
