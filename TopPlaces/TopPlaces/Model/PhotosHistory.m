// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PhotosHistory.h"

#import "FlickrFetcher.h"

NS_ASSUME_NONNULL_BEGIN

#define PHOTOS_HISTORY_PREF_KEY @"history"
static const int kHistoryLogLength = 20;


@implementation PhotosHistory

+ (NSArray<id<PhotoInfo>>*)historyArray {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSData *encodedPhotos = [prefs objectForKey:PHOTOS_HISTORY_PREF_KEY];
  NSArray *photos = [NSKeyedUnarchiver unarchiveObjectWithData:encodedPhotos];
  if (!photos) {
    photos = [[NSArray alloc] init];
  }
  return photos;
}


+ (void)addPhotoInfo:(id<PhotoInfo>)photoInfo {
  NSMutableArray *photos = [[PhotosHistory historyArray] mutableCopy];
  
  // if the photoInfo is already in the NSUserDefaults, delete it
  NSUInteger key = [photos indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    id<PhotoInfo> other = (id<PhotoInfo>)obj;
    return [photoInfo.url isEqual:other.url]; //assume that url is unique
  }];
  
  if (key != NSNotFound) {
    [photos removeObjectAtIndex:key];
  }
  
  [photos insertObject:photoInfo atIndex:0];
  
  // maintain max length
  if ([photos count] > kHistoryLogLength) {
    [photos removeLastObject];
  }
  
  // set the photos back in the NSUserDefault
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSData *encodedPhotos = [NSKeyedArchiver archivedDataWithRootObject:photos];
  [prefs setObject:encodedPhotos forKey:PHOTOS_HISTORY_PREF_KEY];
  [prefs synchronize];
}

@end

NS_ASSUME_NONNULL_END
