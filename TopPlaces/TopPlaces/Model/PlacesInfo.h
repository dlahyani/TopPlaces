// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

NS_ASSUME_NONNULL_BEGIN

/// Abstraction for a place description that can be presented to the user
@protocol PlaceInfo <NSObject>

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

