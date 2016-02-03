// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
@import Foundation;
NS_ASSUME_NONNULL_BEGIN

@interface PhotosHistory : NSObject
+ (void) addPhotoInfo:(NSDictionary*)photoInfo;
+ (NSArray*) historyArray;
@end

NS_ASSUME_NONNULL_END
