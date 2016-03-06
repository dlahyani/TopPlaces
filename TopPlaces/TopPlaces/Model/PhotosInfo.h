// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

NS_ASSUME_NONNULL_BEGIN

/// Photo information absraction
@protocol PhotoInfo <NSCoding>

/// Returns the title of the image
@property (nonatomic, readonly) NSString *title;

/// Returns the details - auxillary info of the image
@property (nonatomic, readonly) NSString *details;

/// Returns the url for downloading the image
@property (nonatomic, readonly) NSURL *url;

@end

NS_ASSUME_NONNULL_END
