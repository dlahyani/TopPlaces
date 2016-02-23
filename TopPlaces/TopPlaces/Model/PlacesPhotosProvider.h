// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "PlacesInfo.h"
#import "PhotosInfo.h"

NS_ASSUME_NONNULL_BEGIN

//Cancellable download task returned by PlacesPhotosProvider
@protocol CancellableTask <NSObject>

/// cancel download in progress, completion handler will be called with error
- (void) cancel;

@end


/// Places and image lists provider abtraction
@protocol PlacesPhotosProvider

typedef void (^DownloadPlacesCompleteBlock)(NSArray<id<PlaceInfo>> *placesInfo, NSError *error);

/// Download the places list
- (id<CancellableTask>)downloadPlacesWithCompletion:
                          (DownloadPlacesCompleteBlock)downloadCompleteBlock;

/// Recieves \c photosInfo containing the array of photo's info and a possible error.
/// If the download succeeds \c error will be nil otherwise the \c photosInfo will be nil
typedef void (^DownloadPhotosInfoCompleteBlock) ( NSArray<id<PhotoInfo>> * _Nullable photosInfo,
                                                 NSError * _Nullable error);

/// Download the photos list of the specific \c placeInfo
- (id<CancellableTask>)downloadPhotosInfoForPlace:(id<PlaceInfo>)placeInfo
                                          withMaxResults:(NSUInteger)maxResults
                                          withCompletion:
                                              (DownloadPhotosInfoCompleteBlock)downloadCompleteBlock;

/// Recieves \c img image instance of photo to download and a possible error.
/// If the download succeeds \c error will be nil otherwise the \c img will be nil
typedef void(^DownloadPhotoCompleteBlock)(UIImage * _Nullable img, NSError * _Nullable error);

/// Download the photo linked from \c photoInfo
- (id<CancellableTask>)downloadPhoto:(id<PhotoInfo>)photoInfo
                      withCompletion:(DownloadPhotoCompleteBlock)downloadCompleteBlock;

@end

NS_ASSUME_NONNULL_END
