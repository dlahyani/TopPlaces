//
//  AppDelegate.h
//  TopPlaces
//
//  Created by Gennadi Iosad on 26/01/2016.
//  Copyright © 2016 LightricksNoobsDepartment. All rights reserved.
//

#import "PlacesPhotosProvider.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id<PlacesPhotosProvider> placesPhotosProvider;

@end

