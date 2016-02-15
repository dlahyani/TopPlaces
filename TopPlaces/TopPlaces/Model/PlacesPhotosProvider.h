// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

NS_ASSUME_NONNULL_BEGIN

/// Abstraction for a place description that can be presented to the user
@protocol PlaceInfo<NSObject>


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



/// Photo information absraction
@protocol PhotoInfo<NSCoding>

/// Returns the title of the image
@property (nonatomic, readonly) NSString *title;


/// Returns the details - auxillary info of the image
@property (nonatomic, readonly) NSString *details;

/// Returns the url for downloading the image
@property (nonatomic, readonly) NSURL *url;

@end



/// Places and image lists provider abtraction
@protocol PlacesPhotosProvider

/// Download the places list
- (NSArray<id<PlaceInfo>> *)downloadPlaces;


/// Download the photos list of the specific \c placeInfo
- (NSArray<id<PhotoInfo>> *)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                        withMaxResults:(NSUInteger)maxResults;

/// Download the photo linked from \c photoInfo
- (UIImage *)downloadPhoto:(id<PhotoInfo>)photoInfo;

@end

NS_ASSUME_NONNULL_END
