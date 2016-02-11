// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.
NS_ASSUME_NONNULL_BEGIN
/// VC for presenting a photo given the photo data in Flickr format.
@interface DetailsPhotoViewController : UIViewController

/// The photo data we want to present the image of.
/// Should be set before segueing to this VC in prepareForSegue
@property (strong, nonatomic) NSDictionary *photoInfo;
@end

NS_ASSUME_NONNULL_END
