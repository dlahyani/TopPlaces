// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "DetailsPhotoViewController.h"

#import "PhotosHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsPhotoViewController()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *noImageLoadedView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSURLSessionTask *downloadTask;
@end

@implementation DetailsPhotoViewController

#pragma mark -
#pragma mark UIViewController overrides
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  self.scrollView.delegate = self;
  
  UITapGestureRecognizer *doubleTapRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(scrollViewDoubleFingerTapped:)];
  
  doubleTapRecognizer.numberOfTapsRequired = 2;
  doubleTapRecognizer.numberOfTouchesRequired = 1;
  [self.scrollView addGestureRecognizer:doubleTapRecognizer];

  [self loadImage];
  
  NSLog(@"DetailsPhotoViewController::viewDidLoad self %p", self);
}


- (void)scrollViewDoubleFingerTapped:(UITapGestureRecognizer*)recognizer {
  //if already zoomed out - zoom in a bit
  if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
    [self.scrollView setZoomScale:self.scrollView.zoomScale*2 animated:YES];
  } else {
    //zoom out
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
  }
}


- (void)viewDidAppear:(BOOL)animated {
  NSLog(@"DetailsPhotoViewController::viewDidAppear");
  [super viewDidAppear:animated];
}


- (void)viewDidLayoutSubviews {
  NSLog(@"DetailsPhotoViewController::viewDidLayoutSubviews");
  [super viewDidLayoutSubviews];

  if (self.imageView) {
    [self aspectFitImage];
  }
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  NSLog(@"DetailsPhotoViewController::viewDidDisappear");
  [self.downloadTask cancel];
}

#pragma mark -
#pragma mark UIScrollViewDelegate impl
#pragma mark -

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  // The scroll view has zoomed, so you need to re-center the contents
  [self centerScrollViewContents];
}

#pragma mark -
#pragma mark aux logic
#pragma mark -

- (void)loadImage {
  //in ipad info can be missing
  if (!self.photoInfo) {
    return;
  }

  [PhotosHistory addPhotoInfo:self.photoInfo];
  
  self.noImageLoadedView.hidden = YES;
  [self.spinner startAnimating];

  __weak DetailsPhotoViewController *weakSelf = self;
  self.downloadTask =
      [self.placesPhotosProvider downloadPhoto:self.photoInfo
                             completionHandler:^(UIImage *img, NSError *error) {
                               [weakSelf.spinner stopAnimating];
                               
                               //if download failed
                               if (!img || error) {
                                 weakSelf.noImageLoadedView.hidden = NO;
                                 return;
                               }
                               
                               weakSelf.title = weakSelf.photoInfo.title;
                               
                               weakSelf.imageView = [[UIImageView alloc] initWithImage:img];
                               weakSelf.imageView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
                               
                               [weakSelf.scrollView addSubview:weakSelf.imageView];
                               weakSelf.scrollView.contentSize = weakSelf.imageView.bounds.size;
                             }];

}


- (void)centerScrollViewContents {
  CGPoint imageViewCenter = self.imageView.center;
  //we image size after scroll's view transform - thus we take the frame
  CGSize imageViewSize = CGRectStandardize(self.imageView.frame).size;
  CGSize scrollViewSize = CGRectStandardize(self.scrollView.bounds).size;
  
  CGPoint scrollViewCenter = [self scrollViewCenter];
  
  //touch the center only if scrollView exceeds the image
  
  if (imageViewSize.width <= scrollViewSize.width) {
    imageViewCenter.x = scrollViewCenter.x;
  }
  
  if (imageViewSize.height <= scrollViewSize.height) {
    imageViewCenter.y = scrollViewCenter.y;
  }
  
  //this will put the image in the center and add the padding as needed
  self.imageView.center = imageViewCenter;
}


- (void)aspectFitImage {
  CGSize scrollViewSize = CGRectStandardize(self.scrollView.bounds).size;
  CGSize imageSize = CGRectStandardize(self.imageView.bounds).size;
  
  CGFloat scaleWidth = scrollViewSize.width / imageSize.width;
  CGFloat scaleHeight = scrollViewSize.height / imageSize.height;

  //set the zoom scale so all the image fits the screen
  self.scrollView.minimumZoomScale = MIN(scaleWidth, scaleHeight);
  self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
  self.scrollView.maximumZoomScale = 3;
  
  //start zoomed out and centered
  [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
  

  self.imageView.center = [self scrollViewCenter];
}


//return the scroll view center
- (CGPoint)scrollViewCenter {
  CGSize scrollViewSize = CGRectStandardize(self.scrollView.bounds).size;
  UIEdgeInsets contentInset = self.scrollView.contentInset;
  CGFloat centerX = (scrollViewSize.width - contentInset.left - contentInset.right)/2.0;
  CGFloat centerY = (scrollViewSize.height - contentInset.top - contentInset.bottom)/2.0;
  
  return CGPointMake(centerX, centerY);
}

#pragma mark -
#pragma mark for debug
#pragma mark -

NSString *StrCGPoint(CGPoint p) {
  return [NSString stringWithFormat:@"{%d, %d}", (int)p.x, (int)p.y];
}


NSString *StrCGRect(CGRect r) {
  return [NSString stringWithFormat:@"o - {%d, %d}, s - {%d, %d}", (int)r.origin.x, (int)r.origin.y,
              (int)r.size.width, (int)r.size.height];
}


@end

NS_ASSUME_NONNULL_END
