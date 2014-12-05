//
//  ViewController.h
//  CollectionViewFun
//
//  Created by joseph hoffman on 2/20/13.
//  Copyright (c) 2013 Joe Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface CollectionViewController : UICollectionViewController <UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *photoImages;
@property (strong,nonatomic) NSArray *photoDescriptions;
@property (strong,nonatomic) NSArray *falbumImages;

@end
