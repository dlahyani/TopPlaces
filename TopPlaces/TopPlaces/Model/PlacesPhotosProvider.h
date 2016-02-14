// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

NS_ASSUME_NONNULL_BEGIN
@protocol PlaceInfo

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *details;
@property (nonatomic, readonly) NSString *country;

- (NSComparisonResult) compare:(id<PlaceInfo>)other;
- (NSURL*) getURLOfPhotoInfoArrayWithMaxLength:(NSUInteger)maxLength;

@end

@protocol PhotoInfo

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *details;
@property (nonatomic, readonly) NSURL *url;

@end

@protocol PlacesPhotosProvider

- (NSArray<id<PlaceInfo>> *)downloadPlaces;

- (NSArray<id<PhotoInfo>> *)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                        withMaxResults:(NSUInteger)maxResults;

- (UIImage *)downloadPhoto:(id<PhotoInfo>)photoInfo;

@end
NS_ASSUME_NONNULL_END
