// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"

NS_ASSUME_NONNULL_BEGIN

/// Implementation of cancellable task returned by FlickrPlacesPhotosProvider
@interface FlickrCancellableTask : NSObject<CancellableTask>

- (instancetype) init NS_UNAVAILABLE;

/// Init cancellable task by wrapping \c task
- (instancetype) initWithDownloadTask:(NSURLSessionDownloadTask *)task NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
