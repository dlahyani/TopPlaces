// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN
@interface PlacesTableViewController : UITableViewController
@property (strong, nonatomic) NSArray *photos;
- (void) fetchPhotos;
@end

NS_ASSUME_NONNULL_END
