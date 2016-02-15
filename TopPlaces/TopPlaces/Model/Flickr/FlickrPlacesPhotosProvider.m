// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrPlacesPhotosProvider.h"

#import "FlickrFetcher.h"
#import "FlickrPhotoInfo.h"
#import "FlickrPlaceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrPlacesPhotosProvider

- (NSArray<id<PlaceInfo>> *)downloadPlaces {
  //download and convert places to array
  NSURL *url = [FlickrFetcher URLforTopPlaces];
  NSData *jsonResults = [NSData dataWithContentsOfURL:url];
  NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                      options:0
                                                                        error:NULL];
  
  NSArray *placesData = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
  
  NSMutableArray *placesInfo = [[NSMutableArray alloc] initWithCapacity:[placesData count]];
  for (NSDictionary *d in placesData) {
    [placesInfo addObject:[[FlickrPlaceInfo alloc] initWithDictionary:d]];
  }
  return placesInfo;
}


- (NSArray<id<PhotoInfo>> *)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                        withMaxResults:(NSUInteger)maxResults {
  // download the photos list info and convert it array
  NSURL *url = [placeInfo urlOfPhotoInfoArrayWithMaxLength:maxResults];
  
  NSData *jsonResults = [NSData dataWithContentsOfURL:url];
  NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                      options:0
                                                                        error:NULL];
  NSArray *photosData = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];

  
  return [self convertPhotosDataToInfoArray:photosData];
}

- (NSArray<id<PhotoInfo>> *)convertPhotosDataToInfoArray:(NSArray *)photosData {
  NSMutableArray<FlickrPhotoInfo*> *photosInfo = [[NSMutableArray alloc] initWithCapacity:[photosData count]];
  for (NSDictionary *d in photosData) {
    [photosInfo addObject:[[FlickrPhotoInfo alloc] initWithDictionary:d]];
  }
  return photosInfo;
}


- (UIImage *)downloadPhoto:(id<PhotoInfo>)photoInfo {
  
  NSURL *photoUrl = photoInfo.url;
  
  if (!photoUrl) {
    return nil;
  }

  NSData *imageData = [NSData dataWithContentsOfURL:photoUrl];
  UIImage *img = [UIImage imageWithData:imageData];
  NSLog(@"img downloaded %p", img);
  return img;
}

@end


NS_ASSUME_NONNULL_END
