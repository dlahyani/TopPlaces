// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "DetailsPhotoViewController.h"
#import "FlickrFetcher.h"
#import "PhotosHistory.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsPhotoViewController()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *noImageLoadedView;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation DetailsPhotoViewController


- (void) viewDidLoad
{
  [super viewDidLoad];
  self.scrollView.delegate = self;
  
  UITapGestureRecognizer *doubleTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(scrollViewTwoFingerTapped:)];
  
  doubleTapRecognizer.numberOfTapsRequired = 2;
  doubleTapRecognizer.numberOfTouchesRequired = 1;
  [self.scrollView addGestureRecognizer:doubleTapRecognizer];
  //in ipad info can be missing
  if (self.photoInfo) {
    [self loadImage:self.photoInfo];
  }
  
  NSLog(@"DetailsPhotoViewController::viewDidLoad self %p", self);
}
//- (void)viewWillTransitionToSize:(CGSize)size
//       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//  if (self.imageView) {
//    [self aspectFitImage];
//  }
//}

- (void)scrollViewDoubleFingerTapped:(UITapGestureRecognizer*)recognizer
{
  //if already zoomed out - zoom in a bit
  if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
    [self.scrollView setZoomScale:self.scrollView.zoomScale*2 animated:YES];
  } else {
    //zoom out
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
  }
}

- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  NSLog(@"DetailsPhotoViewController::viewDidAppear");
  
}
- (void) viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  NSLog(@"DetailsPhotoViewController::viewDidLayoutSubviews");
//  
  if (self.imageView) {
    [self aspectFitImage];
  }
  NSLog(@"imageView.frame %@", NSStringFromCGRect(self.imageView.frame));
  NSLog(@"scrollView.frame %@", NSStringFromCGRect(self.scrollView.frame));
  NSLog(@"---");
  
}
//
//- (void) viewWillLayoutSubviews
//{
//  [super viewWillLayoutSubviews];
//  
//  NSLog(@"DetailsPhotoViewController::viewWillLayoutSubviews");
//  //
//  if (self.imageView) {
//    [self aspectFitImage];
//  }
//  NSLog(self.imageView.description);
//  NSLog(self.scrollView.description);
//  NSLog(@"---");
//  
//}

- (void)loadImage:(NSDictionary *)photoInfo
{
  [PhotosHistory addPhotoInfo:photoInfo];
  NSURL *photoUrl = [FlickrFetcher URLforPhoto:self.photoInfo format:FlickrPhotoFormatOriginal];
//TODO: enable this when done
  //  if (!photoUrl) {
//    photoUrl = [FlickrFetcher URLforPhoto:self.photoInfo format:FlickrPhotoFormatLarge];
//  }
  
  //NSLog(@"TopPlacesDetailsPhotoViewController %p::setPhotoInfo %p", self, self.photoInfo);

  self.noImageLoadedView.hidden = YES;
  [self.spinner startAnimating];

  __weak DetailsPhotoViewController *weakSelf = self;
  dispatch_queue_t fetchPhoto = dispatch_queue_create("picture of photo", NULL);
  dispatch_async(fetchPhoto, ^(void){
    //get the image
    NSData *imageData = [NSData dataWithContentsOfURL:photoUrl];
    UIImage *img = [UIImage imageWithData:imageData];
    NSLog(@"img loaded %p", img);
    //show it
    dispatch_async(dispatch_get_main_queue(), ^(void){
      [weakSelf.spinner stopAnimating];
      
      //if download failed
      if (!img) {
        weakSelf.noImageLoadedView.hidden = NO;
        return;
      }

      weakSelf.title = [weakSelf.photoInfo valueForKeyPath:FLICKR_PHOTO_TITLE];
      
      //if no title go with description
      if ([weakSelf.title length] == 0) {
        weakSelf.title = [weakSelf.photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
      }
      weakSelf.imageView = [[UIImageView alloc] initWithImage:img];
      weakSelf.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
      
      [weakSelf.scrollView addSubview:weakSelf.imageView];
      weakSelf.scrollView.contentSize = weakSelf.imageView.bounds.size;
      
      //TODO: why do we need this, why scrollView origin is not 0
      weakSelf.scrollView.scrollIndicatorInsets   = UIEdgeInsetsMake(0, 0, 0, 0);
      weakSelf.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);//TODO: why do we need this
    });
  });
}



// UIScrollViewDelegate method
- (UIView * __nullable)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
  return self.imageView;
}

// UIScrollViewDelegate method
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  // The scroll view has zoomed, so you need to re-center the contents
  [self centerScrollViewContents];
}


- (void)centerScrollViewContents
{
  NSLog(@"====centerScrollViewContents====");

  CGPoint imageViewCenter = self.imageView.center;
  //we image size after scroll's view transform - thus we take the frame
  CGSize imageViewSize = CGRectStandardize(self.imageView.frame).size;
  
  CGSize scrollViewSize = CGRectStandardize(self.scrollView.bounds).size;
  NSLog(@"imageView.frame %@", NSStringFromCGRect(self.imageView.frame));
  NSLog(@"scrollView.frame %@", NSStringFromCGRect(self.scrollView.frame));
  NSLog(@"imageView.size %@", NSStringFromCGSize(imageViewSize));
  NSLog(@"scrollView.size %@", NSStringFromCGSize(scrollViewSize));

  //touch the center only if scrollView exceeds the image
  
  if (imageViewSize.width <= scrollViewSize.width) {
    imageViewCenter.x = scrollViewSize.width/2.0;
  }
  
  if (imageViewSize.height <= scrollViewSize.height) {
    imageViewCenter.y = scrollViewSize.height/2.0;
  }
  
  //try to remove all the padding
  self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

  //this will put the image in the center and add the padding as needed
  self.imageView.center = imageViewCenter;
  
}


- (void)aspectFitImage
{
  NSLog(@"====aspectFitImage====");
  CGSize scrollViewSize = CGRectStandardize(self.scrollView.bounds).size;
  CGSize imageSize = CGRectStandardize(self.imageView.bounds).size;
  
  CGFloat scaleWidth = scrollViewSize.width / imageSize.width;
  CGFloat scaleHeight = scrollViewSize.height / imageSize.height;

  //set the zoom scale so all the image fits the screen
  self.scrollView.minimumZoomScale = MIN(scaleWidth, scaleHeight);
  self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
  self.scrollView.maximumZoomScale = 3;
  
  //start zoomed out
  [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
  
  [self centerScrollViewContents ];
}
@end

NS_ASSUME_NONNULL_END
