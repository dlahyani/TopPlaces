// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrPlacesPhotosProvider.h"

#import "FlickrFetcher.h"
#import "FlickrPhotoInfo.h"
#import "FlickrPlaceInfo.h"
#import "FlickrCancellableTask.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrPlacesPhotosProvider

- (id<CancellableTask>)downloadPlacesWithCompletion:
        (DownloadPlacesCompleteBlock)downloadCompleteBlock {
  //download and convert places to array
  NSURL *url = [FlickrFetcher URLforTopPlaces];

  id<CancellableTask> task =
      [self downloadDataFromUrl:url withCompletion:^(NSData *data, NSError *error) {
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
        if (downloadCompleteBlock) {
          downloadCompleteBlock(placesInfo, error);
        }
      }];
  
  return task;
}

- (id<CancellableTask>)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                   withMaxResults:(NSUInteger)maxResults
                                   withCompletion:
                                        (DownloadPhotosInfoCompleteBlock)downloadCompleteBlock{
  // download the photos list info and convert it array
  NSURL *url = [placeInfo urlOfPhotoInfoArrayWithMaxLength:maxResults];
  
  id<CancellableTask> task =
      [self downloadDataFromUrl:url withCompletion:^(NSData * _Nullable data,
                                                     NSError * _Nullable error) {
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
        if (downloadCompleteBlock) {
          downloadCompleteBlock(photosInfo, error);
        }
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

- (id<CancellableTask>)downloadPhoto:(id<PhotoInfo>)photoInfo
                      withCompletion:(DownloadPhotoCompleteBlock)downloadCompleteBlock{
  
  NSURL *photoUrl = photoInfo.url;
  
  if (!photoUrl) {
    return nil;
  }

  id<CancellableTask> task =
      [self downloadDataFromUrl:photoUrl
              withCompletion:^(NSData * _Nullable data, NSError * _Nullable error) {
                UIImage *img = nil;
                if (data && !error) {
                  img = [UIImage imageWithData:data];
                }
                if (downloadCompleteBlock) {
                  downloadCompleteBlock(img, error);
                }
              }];
  return task;
}

/// common function used in the interface implementation
- (id<CancellableTask>)downloadDataFromUrl:(NSURL *)url
                             withCompletion:(void(^)(NSData * _Nullable data,
                                                     NSError * _Nullable error))downloadCompleteBlock{
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
                   if (downloadCompleteBlock) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                       NSLog(@"data download complete %p", data);
                       downloadCompleteBlock(data, error);
                     });
                   }
                 }];
  
  NSLog(@"data download started");
  [getDataTask resume];
  return [[FlickrCancellableTask alloc ] initWithDownloadTask:getDataTask];
}
@end

NS_ASSUME_NONNULL_END
