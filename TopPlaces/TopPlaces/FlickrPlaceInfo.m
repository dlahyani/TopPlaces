// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrPlaceInfo.h"

#import "FlickrFetcher.h"

NS_ASSUME_NONNULL_BEGIN
@interface FlickrPlaceInfo ()
@property (strong, nonatomic) NSDictionary *placeData;
@end
@implementation FlickrPlaceInfo
- (instancetype) initWithDictionary:(NSDictionary*)dict {
  if (self = [super init]) {
    self.placeData = dict;
  }
  return self;
}

- (NSURL*) getURLOfPhotoInfoArrayWithMaxLength:(NSUInteger)maxLength {
  return [FlickrFetcher URLforPhotosInPlace:[self.placeData valueForKeyPath:FLICKR_PLACE_ID]
                          maxResults:50];
}


@end

NS_ASSUME_NONNULL_END
