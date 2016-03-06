// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesPhotosProvider.h"
#import "PhotosHistory.h"

NS_ASSUME_NONNULL_BEGIN

/// API for accessing persistent history storage based on NSUserDefaults
///
@interface NSUserDefaultsPhotosHistory : NSObject<PhotosHistory>
@end

NS_ASSUME_NONNULL_END
