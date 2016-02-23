// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrCancellableTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlickrCancellableTask ()

/// Download task that can be cancelled
@property (strong, nonatomic) NSURLSessionDownloadTask *task;

@end

@implementation FlickrCancellableTask

- (instancetype) initWithDownloadTask:(NSURLSessionDownloadTask *)task {
  if (self = [super init]) {
    self.task = task;
  }
  return  self;
}

- (void) cancel {
  [self.task cancel];
}

@end

NS_ASSUME_NONNULL_END
