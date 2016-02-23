// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrPlaceInfo : NSObject <PlaceInfo>

- (instancetype)init NS_UNAVAILABLE;

/// Initialize the instance with the \c dict recieved from the Flickr service
- (instancetype)initWithDictionary:(NSDictionary*)dict NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
