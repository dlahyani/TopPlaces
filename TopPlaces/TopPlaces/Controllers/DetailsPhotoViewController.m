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
                               [weakSelf.scrollView addSubview:weakSelf.imageView];
                               weakSelf.scrollView.contentSize = weakSelf.imageView.bounds.size;
                             }];

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

NSString *StrCGSize(CGSize s) {
  return [NSString stringWithFormat:@"size width %d, height %d", (int)s.width, (int)s.height];
}


NSString *StrUIEdgeInsets(UIEdgeInsets ei) {
  return [NSString stringWithFormat:@"insets: top - %d, left %d, right %d bottom %d", (int)ei.top, (int)ei.left,
          (int)ei.right, (int)ei.bottom];
}


@end

NS_ASSUME_NONNULL_END
