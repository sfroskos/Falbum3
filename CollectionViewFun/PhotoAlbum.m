//
//  PhotoAlbum.m
//  CollectionViewFun
//
//  Created by Seth Roskos on 12/4/14.
//  Copyright (c) 2014 Joe Hoffman. All rights reserved.
//

#import "PhotoAlbum.h"

@implementation PhotoAlbum

// Get photos from library
- (NSArray *)getPhotos:(int) numberOfPhotos
{
    NSDate * enddate = [NSDate date];
    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
    [tempFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startdate = [tempFormatter dateFromString:@"2014-12-02"];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    options.predicate = [NSPredicate predicateWithFormat:@"creationDate > %@ AND creationDate < %@",startdate,enddate];
    PHFetchResult *fr = [PHAsset fetchAssetsWithOptions:options];
    NSArray* assetsArray = [fr objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, fr.count)]];
    int numberPhotosFactor = fr.count / numberOfPhotos;
    int photoFactorCount = 1;
    NSMutableArray *imagesArray = [NSMutableArray new];
        if (assetsArray.count>0) {
            for (int idx=0; idx<assetsArray.count; idx++) {
                PHAsset *asset = assetsArray[idx];
                if (asset) {
                    UIImage *assetImage = [self grabImageFromAsset:asset];
                    if (assetImage != nil & photoFactorCount == numberPhotosFactor) {
                        [imagesArray addObject:assetImage];
                        photoFactorCount = 1;
                    }
                    else
                    {photoFactorCount++;}
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
