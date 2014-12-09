//
//  InputTableViewController.h
//  Falbum3
//
//  Created by Seth Roskos on 12/5/14.
//  Copyright (c) 2014 Seth Roskos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTableViewController : UITableViewController <UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *InputNumberOfPhotos;
@property (weak, nonatomic) IBOutlet UIDatePicker *InputStartDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *InputEndDate;
@property (weak, nonatomic) IBOutlet UIPickerView *InputLocation;
@property NSArray *numberOfPhotosArray;
@property int numPhotos;
@property NSArray *locationArray;
@property NSString *location;

- (IBAction)Falbumize:(UIButton *)sender;
@end
