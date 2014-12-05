//
//  PhotoAlbum.m
//  CollectionViewFun
//
//  Created by Seth Roskos on 12/4/14.
//  Copyright (c) 2014 Joe Hoffman. All rights reserved.
//

#import "PhotoAlbum.h"

@implementation PhotoAlbum
- (void)grabAllMediaCompletion:(void (^)(NSArray *, NSArray *))completion
{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    NSMutableArray *allMediaAssetsArray = [NSMutableArray new];
    NSMutableArray *allMediaImagesArray = [NSMutableArray new];
    
    PHFetchResult *fr = [PHAsset fetchAssetsWithOptions:options];
    NSArray* assetsArray = [fr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fr.count)]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        if (fr.count>0) {
            for (int idx=0; idx<fr.count; idx++) {
                PHAsset *asset = fr[idx];
                if (asset) {
                    UIImage *assetImage = [self grabImageFromAsset:asset];
                    if (assetImage != nil) {
                        [allMediaAssetsArray addObject:asset];
                        [allMediaImagesArray addObject:assetImage];
                   }
              }
            }
            if (completion) completion(allMediaAssetsArray, allMediaImagesArray);
        } else {
            if (completion) completion(nil, nil);
        }
    });
}

// Get all photos from library
- (NSArray *)getPhotos
{
PHFetchOptions *options = [[PHFetchOptions alloc] init];
//options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
PHFetchResult *fr = [PHAsset fetchAssetsWithOptions:options];
NSArray* assetsArray = [fr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fr.count)]];
NSMutableArray *imagesArray = [NSMutableArray new];
    if (assetsArray.count>0) {
        for (int idx=0; idx<assetsArray.count; idx++) {
            PHAsset *asset = assetsArray[idx];
            if (asset) {
                UIImage *assetImage = [self grabImageFromAsset:asset];
                if (assetImage != nil) {
                    [imagesArray addObject:assetImage];
                }
            }
        }
    }
    return imagesArray;
}

// Get the UIImage instance from a PHAsset
- (UIImage *)grabImageFromAsset:(PHAsset *)asset
{
    __block UIImage *returnImage;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(200,200)
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:
     ^(UIImage *result, NSDictionary *info) {
         returnImage = result;
     }];
    return returnImage;
}
@end
