// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN

@interface PhotosTableViewController : UITableViewController
- (void) fetchPhotos;   //abstract
@property (strong, nonatomic) NSArray *photosInfo;
@end

NS_ASSUME_NONNULL_END
