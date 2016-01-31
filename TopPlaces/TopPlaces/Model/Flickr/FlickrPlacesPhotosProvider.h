// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN

///Flickr service places and photos provider
@interface FlickrPlacesPhotosProvider : NSObject<PlacesPhotosProvider>

/// Download the photo image linked from \c photoInfo
- (UIImage *)downloadPhoto:(id<PhotoInfo>)photoInfo;

/// download the list of the top places from Flickr
- (NSArray<id<PlaceInfo>> *)downloadPlaces;

/// download the photos list coming from specific \c placeInfo capped by \c maxResults length
- (NSArray<id<PhotoInfo>> *)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                        withMaxResults:(NSUInteger)maxResults;


@end

NS_ASSUME_NONNULL_END
