// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"
NS_ASSUME_NONNULL_BEGIN
//todo: doc
@interface FlickrPlaceInfo : NSObject<PlaceInfo>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary*)dict NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *details;
@property (nonatomic, readonly) NSString *country;

- (NSURL*)urlOfPhotoInfoArrayWithMaxLength:(NSUInteger)maxLength;

- (NSComparisonResult)compare:(id<PlaceInfo>)other;
@end

NS_ASSUME_NONNULL_END
