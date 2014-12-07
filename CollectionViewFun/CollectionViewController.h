//
//  ViewController.h
//  Falbum
//
//  Created by Seth Roskos on 12/3/2014.
//  Copyright (c) 2014 Seth Roskos. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface CollectionViewController : UICollectionViewController <UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *photoImages;
@property (strong,nonatomic) NSArray *photoDescriptions;
@property (strong,nonatomic) NSArray *falbumImages;
@property int numPhotos;

@end
