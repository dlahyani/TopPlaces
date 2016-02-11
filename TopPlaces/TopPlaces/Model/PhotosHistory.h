// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

NS_ASSUME_NONNULL_BEGIN

/// API for accessing persistent history storage.
///
@interface PhotosHistory : NSObject

/// Add the \c photoInfo to the persistent history log as a first item
/// It will automatically truncate the storage size to some length, pruning the oldest items
+ (void) addPhotoInfo:(NSDictionary*)photoInfo;

/// Returns the items that were added history recently
+ (NSArray*) historyArray;
@end

NS_ASSUME_NONNULL_END
