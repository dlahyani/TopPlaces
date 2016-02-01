// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "DetailsPhotoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsPhotoViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
@implementation DetailsPhotoViewController
- (void)setPhotoUrl:(NSURL*) url
{
  _photoUrl = url;
  NSLog(@"TopPlacesDetailsPhotoViewController %p::setPhotoUrl %@", self, url.description);
  dispatch_queue_t fetchPhoto = dispatch_queue_create("picture of photo", NULL);
  dispatch_async(fetchPhoto, ^(void){
    NSData *imageData = [NSData dataWithContentsOfURL:_photoUrl];
    dispatch_async(dispatch_get_main_queue(), ^(void){
      self.imageView.image = [UIImage imageWithData:imageData];
      [self.spinner stopAnimating];
    });
  });
}



@end

NS_ASSUME_NONNULL_END
