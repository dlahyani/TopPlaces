// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrPlacesPhotosProvider.h"

#import "FlickrFetcher.h"
#import "FlickrPhotoInfo.h"
#import "FlickrPlaceInfo.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrPlacesPhotosProvider
- (NSURLSessionDownloadTask *)downloadPlacesWithCompletionHandler:
        (void(^)(NSArray<id<PlaceInfo>> *placesInfo, NSError *error))downloadCompleteBlock {
  //download and convert places to array
  NSURL *url = [FlickrFetcher URLforTopPlaces];

  NSURLSessionDownloadTask *task =
  [self downloadDataFromUrl:url
          completionHandler:^(NSData *data, NSError *error) {
            NSMutableArray *placesInfo = nil;
            if (data && !error) {
              NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:data
                                                                                  options:0
                                                                                    error:NULL];
              
              NSArray *placesData = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
              if (placesData) {
                placesInfo = [[NSMutableArray alloc] initWithCapacity:[placesData count]];
                for (NSDictionary *d in placesData) {
                  [placesInfo addObject:[[FlickrPlaceInfo alloc] initWithDictionary:d]];
                }
              }
            }
            downloadCompleteBlock(placesInfo, error);
          }];
  return task;
}


- (NSURLSessionDownloadTask *)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                          withMaxResults:(NSUInteger)maxResults
                                        completionHandler:(void(^)(NSArray<id<PhotoInfo>> *photosInfo,
                                                              NSError *error))downloadCompleteBlock{
  // download the photos list info and convert it array
  NSURL *url = [placeInfo urlOfPhotoInfoArrayWithMaxLength:maxResults];
  
  NSURLSessionDownloadTask *task =
      [self downloadDataFromUrl:url
           completionHandler:^(NSData *data, NSError *error) {
             NSArray<id<PhotoInfo>> *photosInfo = nil;
             if (data && !error) {
               NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:data
                                                                                   options:0
                                                                                     error:NULL];
               NSArray *photosData = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
               if (photosData) {
                 photosInfo = [self convertPhotosDataToInfoArray:photosData];
               }
             }
             
             downloadCompleteBlock(photosInfo, error);
           }];
  return task;
  
}

- (NSArray<id<PhotoInfo>> *)convertPhotosDataToInfoArray:(NSArray *)photosData {
  NSMutableArray<FlickrPhotoInfo*> *photosInfo = [[NSMutableArray alloc]
                                                      initWithCapacity:[photosData count]];
  for (NSDictionary *d in photosData) {
    [photosInfo addObject:[[FlickrPhotoInfo alloc] initWithDictionary:d]];
  }
  return photosInfo;
}


- (NSURLSessionDownloadTask *)downloadPhoto:(id<PhotoInfo>)photoInfo
                           completionHandler:(void(^)(UIImage *img,
                                                     NSError *error))downloadCompleteBlock{
  
  NSURL *photoUrl = photoInfo.url;
  
  if (!photoUrl) {
    return nil;
  }

  NSURLSessionDownloadTask *task =
      [self downloadDataFromUrl:photoUrl
              completionHandler:^(NSData *data, NSError *error) {
                UIImage *img = nil;
                if (data && !error) {
                  img = [UIImage imageWithData:data];
                }
                downloadCompleteBlock(img, error);
              }];
  return task;
}


/// common function used in the interface implementation
- (NSURLSessionDownloadTask *)downloadDataFromUrl:(NSURL *)url
                             completionHandler:(void(^)(NSData *data,
                                                        NSError *error))downloadCompleteBlock{
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDownloadTask *getDataTask =
      [session downloadTaskWithURL:url
                 completionHandler:^(NSURL *location,
                                     NSURLResponse *response,
                                     NSError *error) {
                   NSData *data = nil;
                   if (!error) {
                     //get data from the temporary storage
                     data = [NSData dataWithContentsOfURL:location];
                   }
                   dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"data download complete %p", data);
                     downloadCompleteBlock(data, error);
                   });
                 }];
  
  NSLog(@"data download started");
  [getDataTask resume];
  return getDataTask;
}
@end


NS_ASSUME_NONNULL_END
