//
//  AppDelegate.h
//  TopPlaces
//
//  Created by Gennadi Iosad on 26/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "PlacesPhotosProvider.h"
#import "PhotosHistory.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) id<PlacesPhotosProvider> placesPhotosProvider;
@property (strong, nonatomic, readonly) id<PhotosHistory> photosHistory;

@end

