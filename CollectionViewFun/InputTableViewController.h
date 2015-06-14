//
//  InputTableViewController.h
//  Falbum3
//
//  Created by Seth Roskos on 12/5/14.
//  Copyright (c) 2014 Seth Roskos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTableViewController : UITableViewController <UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate> {
    UIPickerView *pickerView;
}
//@property (weak, nonatomic) IBOutlet UIPickerView *InputNumberOfPhotos;
//@property (weak, nonatomic) IBOutlet UIDatePicker *InputStartDate;
//@property (weak, nonatomic) IBOutlet UIDatePicker *InputEndDate;
//@property (weak, nonatomic) IBOutlet UIPickerView *InputLocation;
@property (nonatomic, retain) UIPickerView *pickerView;
@property NSArray *numberOfPhotosArray;
@property int numPhotos;
@property NSArray *locationArray;
@property NSString *location;
@property NSArray *pickerArray;
@property NSString *selectedPickerValue; //Value selected by most recent picker selection
//@property NSArray *indexPaths;
// variables to keep track of indexpaths to add rows for pickers
//@property NSArray *indexPathAbove;
//@property NSArray *indexPathBelow;
@property NSIndexPath *indexPathAbove;
@property NSIndexPath *indexPathBelow;
// variable to keep track of number of rows in table section
@property int numRows;
@property UITableViewCell *currentCell;


//- (IBAction)Falbumize:(UIButton *)sender;
- (IBAction)Falbumize:(UIBarButtonItem *)sender;

//Date Cell Interface
@property (nonatomic, strong) NSArray *cellDataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
// keep track which indexPath points to the cells with the Pickers
@property (nonatomic, strong) NSIndexPath *pickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *datePickerView;
//@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
// End Date Cell Interface

//UIWindow property
@property UIWindow *window;

@end
