// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PhotosHistory.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN
#define PHOTOS_HISTORY_PREF_KEY @"history"
#define HISTORY_LOG_LENGTH 20
@implementation PhotosHistory

+ (NSArray *) historyArray {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSData *encodedPhotos = [prefs objectForKey:PHOTOS_HISTORY_PREF_KEY];
  NSArray *photos = [NSKeyedUnarchiver unarchiveObjectWithData:encodedPhotos];
  if (!photos) {
    photos = [[NSArray alloc] init];
  }
  return photos;
}


+ (void) addPhotoInfo:(id<PhotoInfo>)photoInfo {

  	NSMutableArray *photos = [[PhotosHistory historyArray] mutableCopy];
  // if the photoInfo is already in the NSUserDefaults, delete it
//todo:fix
  //  NSString *photoInfoId = [photoInfo valueForKeyPath:FLICKR_PHOTO_ID];
//  NSUInteger key = [photos indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//    return [photoInfoId isEqualToString:[obj valueForKeyPath:FLICKR_PHOTO_ID]];
//  }];
//  
//  if (key != NSNotFound) {
//    [photos removeObjectAtIndex:key];
//  }
  
  [photos insertObject:photoInfo atIndex:0];
  
  // maintain max length
  if ([photos count] > HISTORY_LOG_LENGTH) {
    [photos removeLastObject];
  }
  
  // add the photo to the NSUserDefault
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSData *encodedPhotos = [NSKeyedArchiver archivedDataWithRootObject:photos];
  [prefs setObject:encodedPhotos forKey:PHOTOS_HISTORY_PREF_KEY];
  [prefs synchronize];
}

@end

NS_ASSUME_NONNULL_END
