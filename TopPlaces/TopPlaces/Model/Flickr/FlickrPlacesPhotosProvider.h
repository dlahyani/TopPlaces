// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN
@interface FlickrPlacesPhotosProvider : NSObject<PlacesPhotosProvider>
- (UIImage *)downloadPhoto:(id<PhotoInfo>)photoInfo;
- (NSArray<id<PlaceInfo>> *)downloadPlaces;
- (NSArray<id<PhotoInfo>> *)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                        withMaxResults:(NSUInteger)maxResults;
@end

NS_ASSUME_NONNULL_END
