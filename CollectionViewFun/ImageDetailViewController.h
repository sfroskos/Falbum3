//
//  ImageDetailViewController.h
//  CollectionViewFun
//
//  Created by joseph hoffman on 2/23/13.
//  Copyright (c) 2013 Joe Hoffman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *truckImageView;
@property (strong, nonatomic) IBOutlet UILabel *truckDetailLabel;
@property (strong, nonatomic) UIImage *photoImage;
@property (strong, nonatomic) NSString *photoLabelText;

@end
