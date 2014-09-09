//
//  ViewController.h
//  CollectionViewFun
//
//  Created by joseph hoffman on 2/20/13.
//  Copyright (c) 2013 Joe Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface CollectionViewController : UICollectionViewController <UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *truckImages;
@property (strong,nonatomic) NSArray *truckDescriptions;

@end
