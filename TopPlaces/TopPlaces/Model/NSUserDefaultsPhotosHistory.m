// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "NSUserDefaultsPhotosHistory.h"

#import "FlickrFetcher.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kPhotosHistoryPrefKey =  @"history";
static const int kHistoryLogLength = 20;

@implementation NSUserDefaultsPhotosHistory

- (NSArray<id<PhotoInfo>>*)historyArray {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSData *encodedPhotos = [prefs objectForKey:kPhotosHistoryPrefKey];
  NSArray *photos = nil;
  
  if (encodedPhotos) {
    photos = [NSKeyedUnarchiver unarchiveObjectWithData:encodedPhotos];
  }
  
  if (!photos) {
    photos = [[NSArray alloc] init];
  }
  return photos;
}

- (void)addPhotoInfo:(id<PhotoInfo>)photoInfo {
  NSMutableArray *photos = [[self historyArray] mutableCopy];
  
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
  [prefs setObject:encodedPhotos forKey:kPhotosHistoryPrefKey];
  [prefs synchronize];
}

@end

NS_ASSUME_NONNULL_END
