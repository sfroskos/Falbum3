//
//  InputTableViewController.m
//  Falbum3
//
//  Created by Seth Roskos on 12/5/14.
//  Copyright (c) 2014 Seth Roskos. All rights reserved.
//

#import "InputTableViewController.h"
#import "CollectionViewController.h"

// Date Cell Definitions
#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view
#define kPickerTag              98     // view tag identifiying the UI picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value
#define kPickerViewKey  @"picker"  // key for obtaining the data source item's picker view


// keep track of which rows have date cells
#define kDateStartRow   3
#define kDateEndRow     4

static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker
static NSString *kOtherCell = @"otherCell";     // the remaining cells at the end
static NSString *kPickerValueCellID = @"ValueCell"; // Cell to hold value from picker
static NSString *kPickerViewCellID = @"ValuePicker"; // PickerView Cell
static NSString *kSpacerCellID = @"SpacerCell"; // PickerView Cell
// End Cell Definitions
@interface InputTableViewController ()

@end

@implementation InputTableViewController

@synthesize pickerView;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set background color
    self.view.backgroundColor = [UIColor blueColor];
    
//    self.source = [[NSMutableArray alloc] initWithObjects:@"EU", @"USA", @"ASIA", nil];
    
//    self.InputNumberOfPhotos = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 110, 280, 300)];
//    self.picker.delegate = self;
//    self.picker.dataSource = self;
//    self.InputNumberOfPhotos.delegate = self;
//    self.InputNumberOfPhotos.dataSource = self;
//    [self.view addSubview:self.InputNumberOfPhotos];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //Initialize arrays of possible values for input criteria
    self.numberOfPhotosArray = [[NSArray alloc] initWithObjects:@"5",@"10",@"20",nil];
    self.locationArray = [[NSArray alloc] initWithObjects:@"NYC",@"LA",nil];
    //Assign tags to Input pickers to reference in other code
    //_InputNumberOfPhotos.tag = 0;
    //_InputLocation.tag = 1;
    //Set Defaults for Picker Row
    //[self.InputNumberOfPhotos selectRow:0 inComponent:0 animated:YES];
    //[self.InputLocation selectRow:0 inComponent:0 animated:YES];
    self.numPhotos = 5; // Initialize number of photos in case none is chosen.
    // Date Cell Code
    // setup our data source
    NSMutableDictionary *numPhotosCell = [@{ kTitleKey : @"Number of Photos",
                                             kPickerViewKey : @"5"} mutableCopy];
    NSMutableDictionary *locationCell = [@{ kTitleKey : @"Location",
                                            kPickerViewKey : @"NYC"} mutableCopy];
    NSMutableDictionary *instructionCell = [@{ kTitleKey : @"Tap a cell to update:" } mutableCopy];
    NSMutableDictionary *dateCell2 = [@{ kTitleKey : @"Start Date",
                                       kDateKey : [NSDate date] } mutableCopy];
    NSMutableDictionary *dateCell3 = [@{ kTitleKey : @"End Date",
                                         kDateKey : [NSDate date] } mutableCopy];
    self.cellDataArray = @[instructionCell, numPhotosCell, locationCell, dateCell2, dateCell3];
    self.numRows = self.cellDataArray.count;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    //[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    // if the locale changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    // End Date Cell Code
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Begin Date Cell Methods
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}

#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion =
        [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] integerValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasDatePickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Determines if the given indexPath has a cell below it with a UIPickerView.
 
 @param indexPath The indexPath to check if its cell has a UIPickerView below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasPicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkPickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIPickerView *checkPicker = (UIPickerView *)[checkPickerCell viewWithTag:kPickerTag];
    
    hasPicker = (checkPicker != nil);
    return hasPicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.cellDataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
        }
    }
}

/*! Updates the UIPickerview's value to match the value in the cell above it.

- (void)updatePicker
{
    if (self.pickerIndexPath != nil)
    {
        UITableViewCell *associatedPickerCell = [self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        
        UIPickerView *targetedPicker = (UIPickerView *)[associatedPickerCell viewWithTag:kPickerTag];
        if (targetedPicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.cellDataArray[self.pickerIndexPath.row - 1];
            [targetedPicker setValue:[itemData valueForKey:kPickerViewKey]];
        }
    }
}
*/

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the UITableViewController has a UIPicker in any of its cells
 */
- (BOOL)hasInlinePicker
{
    return (self.pickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasDatePicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the UIPicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIPicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlinePicker] && self.pickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasDatePicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //adjust the number of rows for adding or removing the picker cells
    return self.numRows;
    
/*    if ([self hasInlineDatePicker])
    {
        // we have a datepicker, so add 1 to the number of rows in this section
        NSInteger numRows = self.cellDataArray.count;
        return ++numRows;
    }
    else if ([self hasInlinePicker])
    {
        // For a UIPickerView we add two cells so add 2 to the number of rows in this section
        NSInteger numRows = self.cellDataArray.count;
        return numRows + 2;
    }
    else {return self.cellDataArray.count;}
*/
 //    return [[self.tableView visibleCells] count];
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = nil;
    
    NSString *cellID = kPickerValueCellID;
    if ((indexPath == self.indexPathAbove) || (indexPath == self.indexPathBelow))
    {
        cellID = kSpacerCellID;
    }
    else if ([self indexPathHasDatePicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerID;     // the current/opened date picker cell
    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    }
    else if ([self indexPathHasPicker:indexPath])
    {
        cellID = kPickerViewCellID; // the UIPickerView cell to input a non-date value
    }
    else
    {
        cellID = kPickerValueCellID; // the cell to display the UIPickerView Value
    }
    self.currentCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (indexPath.row == 0)
    {
        // we decide here that first cell in the table is not selectable (it's just an indicator)
        self.currentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    //
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
    {
        modelRow--;
    }

    NSDictionary *itemData = self.cellDataArray[modelRow];
    
    // proceed to configure our cell
    if ([cellID isEqualToString:kDateCellID])
    {
        // we have either start or end date cells, populate their date field
        //
        self.currentCell.textLabel.text = [itemData valueForKey:kTitleKey];
        self.currentCell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
    }
    else if ([cellID isEqualToString:kPickerValueCellID])
    {
        // this cell is a Value cell for a UIPickerViewCell, populate the fields in the cell
        NSString *cellTitle = [itemData valueForKey:kTitleKey];
        self.currentCell.textLabel.text = cellTitle;
        //if ([cellTitle isEqual: @"Number of Photos"]) {self.pickerArray = self.numberOfPhotosArray;}
        //else if ([cellTitle  isEqual: @"Location"]) {self.pickerArray = self.locationArray;}
        
        self.currentCell.detailTextLabel.text = [itemData valueForKey:kPickerViewKey];
    }
    else if ([cellID isEqualToString:kSpacerCellID])
    {
        // this cell is a non-date cell, just assign it's text label
        //
        //cell.textLabel.text = [itemData valueForKey:kTitleKey];
    }
    return self.currentCell;
}

/*! Removes a UIDatePicker or UIPickerView cell when user clicks away.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
*/
- (void)removeAllPickers
 {
      [self.tableView beginUpdates];
  // remove any date picker or UIPicker cell if it exists
 if ([self hasInlineDatePicker])
 {
     self.datePickerIndexPath = nil;
     [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                        withRowAnimation:UITableViewRowAnimationFade];
     self.numRows--;
 }
 else if ([self hasInlinePicker])
 {
     self.pickerIndexPath = nil;
//     [self.tableView deleteRowsAtIndexPaths:self.indexPathBelow withRowAnimation:UITableViewRowAnimationFade];
     [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathBelow] withRowAnimation:UITableViewRowAnimationFade];
//     [self.tableView deleteRowsAtIndexPaths:self.indexPathAbove withRowAnimation:UITableViewRowAnimationFade];
     [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathAbove] withRowAnimation:UITableViewRowAnimationFade];
     self.indexPathBelow = self.indexPathAbove = nil;
     self.numRows = self.numRows - 2;
 }
 [self.tableView endUpdates];
 }

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    // Did the user click the cell above the date Picker?
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    //Array for current indexpath
    //self.indexPathBelow = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    self.indexPathBelow = [NSIndexPath indexPathForRow:indexPath.row + 1  inSection:0];
    // If the user clicked the cell above the picker remove the picker
    if (sameCellClicked)
    {
        // found a picker below it, so remove it
        //[self.tableView deleteRowsAtIndexPaths:self.indexPathBelow withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathBelow] withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
        self.indexPathBelow = nil;
        self.numRows--;
    }
    else //if another cell was clicked remove any pickers and insert a new one
    {
        // Remove any other existing pickers
        [self removeAllPickers];
        // insert datepicker cell
        self.numRows++;
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        //[self.tableView insertRowsAtIndexPaths:self.indexPathBelow withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathBelow] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

/*! Reveals the picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIPickerView.
 */
- (void)displayInlinePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    // Instantiate NSDictionary with our cell data array
    NSMutableDictionary *itemData = self.cellDataArray[indexPath.row];
    // get value from UIPickerView
    NSString *cellTitle = [itemData valueForKey:kTitleKey];
    if ([cellTitle  isEqual: @"Number of Photos"]) {self.pickerArray = self.numberOfPhotosArray;}
    else if ([cellTitle  isEqual: @"Location"]) {self.pickerArray = self.locationArray;}
    //Did the user click the cell above an existing picker?
    //BOOL sameCellClicked = (self.pickerIndexPath.row == indexPath.row);
    //Array for current indexpath
//061415
    //self.indexPathAbove = @[[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    self.indexPathAbove = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    self.indexPathBelow = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:0];
    // If the user clicked the value cell associated with the picker remove the picker
    if ((self.pickerIndexPath != indexPath)) //Need to add a button to close the uiPicker rather than samecell click
    {
        self.pickerIndexPath = nil;
//        self.indexPaths = [insertIndexPaths copy];
        self.numRows--;
        //[self.tableView deleteRowsAtIndexPaths:self.indexPathBelow withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathBelow] withRowAnimation:UITableViewRowAnimationFade];
        self.numRows--;
        //[self.tableView deleteRowsAtIndexPaths:self.indexPathAbove withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathAbove] withRowAnimation:UITableViewRowAnimationFade];
        self.indexPathBelow = self.indexPathAbove = nil;
    }
    else  //if another cell was clicked remove any pickers and insert a new one
    {
        // Remove any other existing pickers
        [self removeAllPickers];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        self.indexPathAbove = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        self.numRows++;
        //[self.tableView insertRowsAtIndexPaths:self.indexPathAbove withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathAbove] withRowAnimation:UITableViewRowAnimationFade];
        self.indexPathBelow = [NSIndexPath indexPathForRow:indexPath.row + 2 inSection:0];
        self.numRows++;
        //[self.tableView insertRowsAtIndexPaths:self.indexPathBelow withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathBelow] withRowAnimation:UITableViewRowAnimationFade];
        // add 1 to the current indexpath to get the pickerIndexPath because although we just added 2 rows indexpath has not changed
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        // Init the picker view.
        pickerView = [[UIPickerView alloc] init];
        
        // Set the delegate and datasource.
        [pickerView setDataSource: self];
        [pickerView setDelegate: self];
        
        // Calculate the screen's width.
        float screenWidth = [UIScreen mainScreen].bounds.size.width;
        float pickerWidth = screenWidth * 1 / 4;
        
        // Calculate the starting x coordinate.
        float xPoint = 3*(screenWidth / 4);
        [pickerView setFrame: CGRectMake(xPoint, 0.0f, pickerWidth, 180.0f)];
        
        // things. First, let the selection indicator to be shown.
        pickerView.showsSelectionIndicator = YES;
        
        // Allow us to pre-select the first option in the pickerView.
        [pickerView selectRow:0 inComponent:0 animated:YES];
        
        // OK, we are ready. Add the picker in our view.
//        [self.view addSubview: pickerView];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
        //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        //self.currentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        self.currentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.currentCell.contentView addSubview: pickerView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setNeedsDisplay];
//        [UIView animateWithDuration:1.0f
//                              delay:0.0f
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^
//         {
//             self.pickerView.hidden = NO;
//             self.pickerView.center = (CGPoint){self.currentCell.frame.size.width/2, self.tableView.frame.origin.y + self.currentCell.frame.size.height*4};
//         }
//                         completion:nil];

        // always deselect the row containing the selected picker value
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

        // inform UIPickerView of the current value to match the current cell
        //[self updatepicker];
    }
    
        [self.tableView endUpdates];
        
}

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    NSDictionary *itemData = self.cellDataArray[indexPath.row];
    [self.datePickerView setDate:[itemData valueForKey:kDateKey] animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.datePickerView.superview == nil)
    {
        CGRect startFrame = self.datePickerView.frame;
        CGRect endFrame = self.datePickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = CGRectGetHeight(self.view.frame);
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - CGRectGetHeight(endFrame);
        
        self.datePickerView.frame = startFrame;
        
        [self.view addSubview:self.datePickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.datePickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        if (EMBEDDED_DATE_PICKER)
            [self displayInlineDatePickerForRowAtIndexPath:indexPath];
        else
            [self displayExternalDatePickerForRowAtIndexPath:indexPath];
    }
    else if (cell.reuseIdentifier == kPickerValueCellID)
        {[self displayInlinePickerForRowAtIndexPath:indexPath];}
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.cellDataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
}

/*! User chose to change the value by changing the values inside the UIPicker.
 
 @param sender The sender for this action: UIPickerAction.
 */
/*- (IBAction)pickerAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlinePicker])
    {
        // inline picker: update the cell's value "above" the picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.pickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external picker: update the current "selected" cell's value
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIPickerView *targetedPicker = sender;
    
    // Instantiate NSDictionary with our cell data array
    NSMutableDictionary *itemData = self.cellDataArray[targetedCellIndexPath.row];
    // get value from UIPickerView
    NSString *cellTitle = [itemData valueForKey:kTitleKey];
    cell.textLabel.text = cellTitle;
    if ([cellTitle  isEqual: @"Number of Photos"]) {self.pickerArray = self.numberOfPhotosArray;}
    else if ([cellTitle  isEqual: @"Location"]) {self.pickerArray = self.locationArray;}
    
    
    // update our data model
    [itemData setValue:cellTitle forKey:kPickerViewKey];
    
    // update the cell's detail text string
    //cell.detailTextLabel.text = [self.titleForRow objectAtIndex:row];
    cell.detailTextLabel.text = self.selectedPickerValue;
}
*/
/*! User chose to finish using the UIDatePicker by pressing the "Done" button
 (used only for "non-inline" date picker, iOS 6.1.x or earlier)
 
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */
- (IBAction)doneAction:(id)sender
{
    CGRect pickerFrame = self.datePickerView.frame;
    pickerFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    // animate the date picker out of view
    [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.datePickerView.frame = pickerFrame; }
                     completion:^(BOOL finished) {
                         [self.datePickerView removeFromSuperview];
                     }];
    
    // remove the "Done" button in the navigation bar
    self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table cell
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// End Date Cell Methods

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (CGFloat)datePickerView:(UIPickerView *)datePickerView widthForComponent:(NSInteger)component;
{
    return 70;
}

- (CGFloat)datePickerView:(UIPickerView *)datePickerView rowHeightForComponent:(NSInteger)component;
{
    return 20;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return self.pickerArray.count;
}

// Returns the highlighted value to the UI
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    self.selectedPickerValue = [self.pickerArray objectAtIndex:row];
    return self.selectedPickerValue;

}

// Assign variables when value is selected from Picker View - SFR
/*
- (void)datePickerView:(UIPickerView *)datePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (datePickerView.tag == 0)
    {
        self.numPhotos = [[self datePickerView:_InputNumberOfPhotos titleForRow:[_InputNumberOfPhotos selectedRowInComponent:0] forComponent:0]	integerValue];}
    else {
        self.location = [self datePickerView:_InputLocation titleForRow:[_InputLocation selectedRowInComponent:0] forComponent:0];}

    //    self.numPhotos = [[self datePickerView:_InputNumberOfPhotos titleForRow:[_InputNumberOfPhotos selectedRowInComponent:0] forComponent:0]	integerValue];}
}
*/
 #pragma mark - Prepare for Segue
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     CollectionViewController *collectionViewController = (CollectionViewController *)segue.destinationViewController;
     collectionViewController.numPhotos = self.numPhotos;
 }

- (IBAction)Falbumize:(UIBarButtonItem *)sender {
}
@end
