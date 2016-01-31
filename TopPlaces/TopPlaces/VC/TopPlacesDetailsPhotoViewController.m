// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "TopPlacesDetailsPhotoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopPlacesDetailsPhotoViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation TopPlacesDetailsPhotoViewController
- (void)setPhotoUrl:(NSURL*) url
{
  _photoUrl = url;
  NSLog(@"TopPlacesDetailsPhotoViewController %p::setPhotoUrl", self);
}


@end

NS_ASSUME_NONNULL_END
