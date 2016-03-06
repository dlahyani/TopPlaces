// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "DetailsPhotoViewController.h"

#import "PhotosHistory.h"
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsPhotoViewController() <UIScrollViewDelegate>

/// Image download activity indicator
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

/// Scroll view to contain the downloaded image
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/// Text message that should be presented
@property (weak, nonatomic) IBOutlet UILabel *noImageLoadedView;

/// imageView to be presented in the scrollView
@property (strong, nonatomic) UIImageView *imageView;

/// Image download task returned by the placesPhotosProvider
@property (strong, nonatomic) id<CancellableTask> downloadTask;

@end

@implementation DetailsPhotoViewController

#pragma mark -
#pragma mark UIViewController overrides
#pragma mark -

- (void)viewDidLoad {
  [super viewDidLoad];
  self.scrollView.delegate = self;
  [self setupDoubleTapRecognizer];
  [self loadImage];
  NSLog(@"DetailsPhotoViewController::viewDidLoad self %p", self);
}

- (void)setupDoubleTapRecognizer {
  UITapGestureRecognizer *doubleTapRecognizer =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(scrollViewDoubleTapped:)];
  doubleTapRecognizer.numberOfTapsRequired = 2;
  doubleTapRecognizer.numberOfTouchesRequired = 1;
  [self.scrollView addGestureRecognizer:doubleTapRecognizer];
  
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
  //if already zoomed out - zoom in a bit
  if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
    [self.scrollView setZoomScale:self.scrollView.zoomScale*2 animated:YES];
  } else {
    //zoom out
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
  }
}

- (void)viewDidLayoutSubviews {
  NSLog(@"DetailsPhotoViewController::viewDidLayoutSubviews");
  [super viewDidLayoutSubviews];

  if (self.imageView) {
    [self aspectFitImage];
  }
}

- (void) dealloc {
  NSLog(@"DetailsPhotoViewController::dealloc");
  [self.downloadTask cancel];
}

#pragma mark -
#pragma mark UIScrollViewDelegate
#pragma mark -

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  // The scroll view has zoomed, so you need to re-center the contents
  [self centerScrollViewContents];
}

#pragma mark -
#pragma mark Auxiliary Logic
#pragma mark -

- (void)loadImage {
  //in ipad info can be missing
  if (!self.photoInfo) {
    return;
  }

  AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
  [appDelegate.photosHistory addPhotoInfo:self.photoInfo];
  
  self.noImageLoadedView.hidden = YES;
  [self.spinner startAnimating];

  __weak DetailsPhotoViewController *weakSelf = self;
  self.downloadTask =
      [self.placesPhotosProvider downloadPhoto:self.photoInfo
                                withCompletion:^(UIImage *img, NSError *error) {
                                  [weakSelf.spinner stopAnimating];
                                  //if download failed
                                  if (img && !error) {
                                    [weakSelf showImage:img];
                                  } else {
                                    weakSelf.noImageLoadedView.hidden = NO;
                                  }
                             }];

}

- (void)showImage:(UIImage *)image {
  self.title = self.photoInfo.title;
  self.imageView = [[UIImageView alloc] initWithImage:image];
  [self.scrollView addSubview:self.imageView];
  self.scrollView.contentSize = self.imageView.bounds.size;
}

- (void)centerScrollViewContents {
  CGSize scrollViewSize = [self scrollViewVisibleSize];
  // First assume that image center coincides with the contents box center.
  // This is correct when the image is bigger than scrollView due to zoom
  CGPoint imageCenter = CGPointMake(self.scrollView.contentSize.width/2.0,
                                    self.scrollView.contentSize.height/2.0);
  
  CGPoint scrollViewCenter = [self scrollViewCenter];
  
  //if image is smaller than the scrollView visible size - fix the image center accordingly
  if (self.scrollView.contentSize.width < scrollViewSize.width) {
    imageCenter.x = scrollViewCenter.x;
  }
  
  if (self.scrollView.contentSize.height < scrollViewSize.height) {
    imageCenter.y = scrollViewCenter.y;
  }
  
  self.imageView.center = imageCenter;
}

- (void)aspectFitImage {
  CGSize scrollViewSize = [self scrollViewVisibleSize];
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
  CGSize scrollViewSize = [self scrollViewVisibleSize];
  return CGPointMake(scrollViewSize.width/2.0, scrollViewSize.height/2.0);
}

- (CGSize) scrollViewVisibleSize {
  UIEdgeInsets contentInset = self.scrollView.contentInset;
  CGSize scrollViewSize = CGRectStandardize(self.scrollView.bounds).size;
  CGFloat width = scrollViewSize.width - contentInset.left - contentInset.right;
  CGFloat height = scrollViewSize.height - contentInset.top - contentInset.bottom;
  return CGSizeMake(width, height);
}

@end

NS_ASSUME_NONNULL_END
