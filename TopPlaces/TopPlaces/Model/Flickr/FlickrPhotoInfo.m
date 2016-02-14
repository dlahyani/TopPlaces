// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrPhotoInfo.h"

#import "FlickrFetcher.h"

NS_ASSUME_NONNULL_BEGIN
@interface FlickrPhotoInfo ()
@property (strong, nonatomic) NSDictionary *photoData;
@end
@implementation FlickrPhotoInfo

- (instancetype) initWithDictionary:(NSDictionary *)dict {
  if (self = [super init]) {
    self.photoData = dict;
  }
  return self;
}


- (NSString *)title {
  NSString *photoTitle =  [self.photoData valueForKeyPath:FLICKR_PHOTO_TITLE];
  if (![photoTitle length]) {
    photoTitle =  [self.photoData valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if (![photoTitle length]) {
      photoTitle = @"no-title";
    }
  }
  return photoTitle;
}


- (NSString *)details {
  NSString *photoDetails =  [self.photoData valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
  NSString *photoTitle =  [self.photoData valueForKeyPath:FLICKR_PHOTO_TITLE];
  if (![photoTitle length]) {
    if (![photoDetails length]) {
      photoDetails = @"no-details";
    } else {
      photoDetails = @""; //if already used in title
    }
  }
  return photoDetails;
}


- (NSURL *) url {
  NSURL *photoUrl = [FlickrFetcher URLforPhoto:self.photoData format:FlickrPhotoFormatOriginal];
  
  if (!photoUrl) {
    photoUrl = [FlickrFetcher URLforPhoto:self.photoData format:FlickrPhotoFormatLarge];
  }
  return photoUrl;
}


@end

NS_ASSUME_NONNULL_END
