// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "DetailsPhotoViewController.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsPhotoViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
@implementation DetailsPhotoViewController
- (void) viewDidLoad
{
  [super viewDidLoad];
  NSLog(@"DetailsPhotoViewController::viewDidLoad self %p", self);
}
- (void)setPhotoInfo:(NSDictionary *)photoInfo
{
  _photoInfo = photoInfo;
  NSURL *photoUrl = [FlickrFetcher URLforPhoto:self.photoInfo format:FlickrPhotoFormatOriginal];
  NSLog(@"TopPlacesDetailsPhotoViewController %p::setPhotoInfo %p", self, self.photoInfo);
  [self.spinner startAnimating];
  dispatch_queue_t fetchPhoto = dispatch_queue_create("picture of photo", NULL);
  dispatch_async(fetchPhoto, ^(void){
    NSData *imageData = [NSData dataWithContentsOfURL:photoUrl];
    dispatch_async(dispatch_get_main_queue(), ^(void){
      self.imageView.image = [UIImage imageWithData:imageData];
      [self.spinner stopAnimating];
    });
  });
}



@end

NS_ASSUME_NONNULL_END
