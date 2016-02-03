// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PhotosHistory.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN
#define PHOTOS_HISTORY_PREF_KEY @"history"
#define HISTORY_LOG_LENGTH 20
@implementation PhotosHistory

+ (NSArray *) historyArray
{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSArray *photos = [prefs objectForKey:PHOTOS_HISTORY_PREF_KEY];
  return photos;
}


+ (void) addPhotoInfo:(NSDictionary *)photoInfo
{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  
  NSMutableArray *photos = [[prefs objectForKey:PHOTOS_HISTORY_PREF_KEY] mutableCopy];
  if (!photos) {
    photos = [[NSMutableArray alloc] init];
  }
  
  // if the photoInfo is already in the NSUserDefaults, delete it
  NSUInteger key = [photos indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
    return [[photoInfo valueForKeyPath:FLICKR_PHOTO_ID] isEqualToString:[obj valueForKeyPath:FLICKR_PHOTO_ID]];
  }];
  
  if (key != NSNotFound) {
    [photos removeObjectAtIndex:key];
  }
  
  [photos insertObject:photoInfo atIndex:0];
  
  // maintain max length
  if ([photos count] > HISTORY_LOG_LENGTH) {
    [photos removeLastObject];
  }
  
  // add the photo to the NSUserDefault
  [prefs setObject:photos forKey:PHOTOS_HISTORY_PREF_KEY];
  [prefs synchronize];
}

@end

NS_ASSUME_NONNULL_END
