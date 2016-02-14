// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Gennadi Iosad.

#import "FlickrPlaceInfo.h"

#import "FlickrFetcher.h"

NS_ASSUME_NONNULL_BEGIN
@interface FlickrPlaceInfo ()
@property (strong, nonatomic) NSDictionary *placeData;
@end
@implementation FlickrPlaceInfo
- (instancetype) initWithDictionary:(NSDictionary*)dict {
  if (self = [super init]) {
    self.placeData = dict;
  }
  return self;
}


- (NSString *)title {
  NSString *placeName = [self.placeData valueForKeyPath:FLICKR_PLACE_NAME];
  NSArray *components = [placeName componentsSeparatedByString:@", "];
  return [components firstObject];
}


- (NSString *)details {
  NSString *placeName = [self.placeData valueForKeyPath:FLICKR_PLACE_NAME];
  NSArray *components = [placeName componentsSeparatedByString:@", "];
  NSString *details = @"-";
  if ([components count] >= 3) {
    //cut out the middle of the placesInfo array (all but the first and the last one)
    details = [[components subarrayWithRange:NSMakeRange(1, [components count] - 2)] componentsJoinedByString:@", "];
  }
  return details;
}


- (NSString *)country {
  //TODO: review and possibly use extract...
  NSString *placeName = [self.placeData valueForKeyPath:FLICKR_PLACE_NAME];
  NSArray *components = [placeName componentsSeparatedByString:@", "];
  return [components lastObject];
}


- (NSURL*) getURLOfPhotoInfoArrayWithMaxLength:(NSUInteger)maxLength {
  return [FlickrFetcher URLforPhotosInPlace:[self.placeData valueForKeyPath:FLICKR_PLACE_ID]
                          maxResults:(int)maxLength];
}


- (NSComparisonResult) compare:(id<PlaceInfo>)other {
  //TODO: check if cast is legit
  NSString *otherPlaceName = [((FlickrPlaceInfo *)other).placeData valueForKeyPath:FLICKR_PLACE_NAME];
  NSString *placeName = [self.placeData valueForKeyPath:FLICKR_PLACE_NAME];
  
  return [placeName compare:otherPlaceName];
}

@end

NS_ASSUME_NONNULL_END
