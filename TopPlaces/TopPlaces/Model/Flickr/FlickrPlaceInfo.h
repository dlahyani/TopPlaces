// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"
NS_ASSUME_NONNULL_BEGIN

@interface FlickrPlaceInfo : NSObject<PlaceInfo>

- (instancetype)init NS_UNAVAILABLE;

/// Initialize the instance with the \c dict recieved from the Flickr service
- (instancetype)initWithDictionary:(NSDictionary*)dict NS_DESIGNATED_INITIALIZER;

/// Returns the URL to download the list of the photos from the place,
/// the list length is bounded by \c maxLength
- (NSURL*)urlOfPhotoInfoArrayWithMaxLength:(NSUInteger)maxLength;

/// Compares to another instance of PlaceInfo conforming object
- (NSComparisonResult)compare:(id<PlaceInfo>)other;

/// Returns the title of the place
@property (nonatomic, readonly) NSString *title;

/// Returns additional details of the place
@property (nonatomic, readonly) NSString *details;

/// Returns the country of the place
@property (nonatomic, readonly) NSString *country;

@end

NS_ASSUME_NONNULL_END
