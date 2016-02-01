// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "DetailsPhotoViewController.h"
#import "FlickrFetcher.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsPhotoViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
//TODO: enable this when done
  //  if (!photoUrl) {
//    photoUrl = [FlickrFetcher URLforPhoto:self.photoInfo format:FlickrPhotoFormatLarge];
//  }
  photoUrl = [FlickrFetcher URLforPhoto:self.photoInfo format:FlickrPhotoFormatLarge];
  NSLog(@"TopPlacesDetailsPhotoViewController %p::setPhotoInfo %p", self, self.photoInfo);
  [self.spinner startAnimating];
  dispatch_queue_t fetchPhoto = dispatch_queue_create("picture of photo", NULL);
  dispatch_async(fetchPhoto, ^(void){
    NSData *imageData = [NSData dataWithContentsOfURL:photoUrl];
    dispatch_async(dispatch_get_main_queue(), ^(void){
      self.imageView.image = [UIImage imageWithData:imageData];
      [self.spinner stopAnimating];
//      NSString *photoTitle =  //      NSString *photoDetails =  [self.photosInfo[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
//      todo:fix
      self.title = [self.photoInfo valueForKeyPath:FLICKR_PHOTO_TITLE];

    });
  });
}



@end

NS_ASSUME_NONNULL_END
