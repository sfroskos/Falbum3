//
//  PhotoAlbum.h
//  Falbum
//
//  Created by Seth Roskos on 12/4/14.
//  Copyright (c) 2014 Seth Roskos. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;
@import CoreGraphics;

@interface PhotoAlbum : NSObject
- (UIImage *)grabImageFromAsset:(PHAsset *)asset;
- (NSArray *)getPhotos:(int) numberOfPhotos;
//- (NSDictionary *)setAlbumCriteria;
//@property NSMutableDictionary *albumCriteria;
@end
