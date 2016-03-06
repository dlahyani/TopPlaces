// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN

/// Flickr specific implementation of the PhotoInfo protocol
@interface FlickrPhotoInfo : NSObject<PhotoInfo>

- (instancetype)init NS_UNAVAILABLE;

/// Initialize the instance with the \c dict recieved from the Flickr service
- (instancetype)initWithDictionary:(NSDictionary*)dict NS_DESIGNATED_INITIALIZER;

/// Returns the title of the image
@property (nonatomic, readonly) NSString *title;

/// Returns the details - auxillary info of the image
@property (nonatomic, readonly) NSString *details;

/// Returns the url for downloading the image
@property (nonatomic, readonly) NSURL *url;

@end

NS_ASSUME_NONNULL_END
