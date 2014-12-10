//
//  InputTableViewController.m
//  Falbum3
//
//  Created by Seth Roskos on 12/5/14.
//  Copyright (c) 2014 Joe Hoffman. All rights reserved.
//

#import "InputTableViewController.h"
#import "CollectionViewController.h"

@interface InputTableViewController ()

@end

@implementation InputTableViewController

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor blueColor];
    
//    self.source = [[NSMutableArray alloc] initWithObjects:@"EU", @"USA", @"ASIA", nil];
    
/*    UIButton *pressme = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 280, 80)];
    [pressme setTitle:@"Press me!!!" forState:UIControlStateNormal];
    pressme.backgroundColor = [UIColor lightGrayColor];
    [pressme addTarget:self action:@selector(pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pressme];
*/
    self.InputNumberOfPhotos = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 110, 280, 300)];
//    self.picker.delegate = self;
//    self.picker.dataSource = self;
    [self.view addSubview:self.InputNumberOfPhotos];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.numberOfPhotosArray = [[NSArray alloc] initWithObjects:@"5",@"10",@"20",nil];
    self.locationArray = [[NSArray alloc] initWithObjects:@"NYC",@"LA",nil];
    _InputNumberOfPhotos.tag = 0;
    _InputLocation.tag = 1;
    //Set Defaults for Picker Row
    [self.InputNumberOfPhotos selectRow:0 inComponent:0 animated:YES];
    [self.InputLocation selectRow:0 inComponent:0 animated:YES];
    self.numPhotos = 5; // Initialize number of photos in case none is chosen.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
{
    return 70;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
{
    return 20;
}

//Format Date Pickers
/*-(UIView *)UIDatepicker:(UIDatePicker *)UIDatepicker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
    {
        UILabel *lblDate = [[UILabel alloc] init];
        [lblDate setFont:[UIFont fontWithName:@"Arial" size:25.0]];
        [lblDate setTextColor:[UIColor whiteColor]];
        [lblDate setBackgroundColor:[UIColor clearColor]];
        return lblDate;
    }
*/
//Format UIPickers
/*-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
    {
        UILabel *lblDate = [[UILabel alloc] init];
        [lblDate setFont:[UIFont fontWithName:@"Arial" size:25.0]];
        [lblDate setTextColor:[UIColor whiteColor]];
        [lblDate setBackgroundColor:[UIColor clearColor]];
        return lblDate;
    }
*/
//-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//    {
//        UILabel *lblDate = [[UILabel alloc] init];
//        [lblDate setFont:[UIFont fontWithName:@"Arial" size:25.0]];
//        [lblDate setTextColor:[UIColor whiteColor]];
//        [lblDate setBackgroundColor:[UIColor clearColor]];
//        if (component == 0) // Date
//            {
//                int n = -INT16_MAX / 2 + row;
//                NSDate *aDate = [NSDate dateWithTimeIntervalSinceNow:n*24*60*60];
//                NSDateComponents *components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
//                NSDate *today = [self.calendar dateFromComponents:components];
//                components = [self.calendar components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
//                NSDate *otherDate = [self.calendar dateFromComponents:components];
//                if ([today isEqualToDate:otherDate]) { [lblDate setText:@"Today"]; }
//                else
//                    {
//                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//                    formatter.locale = [NSLocale currentLocale];
//                    formatter.dateFormat = @"EEE MMM d";
//                    [lblDate setText:[formatter stringFromDate:aDate]]; }
//                    lblDate.textAlignment = NSTextAlignmentRight; }
//                else if (component == 1) // Hour
//                    {
//                    int max = (int)[self.calendar maximumRangeOfUnit:NSHourCalendarUnit].length;
//                    [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]]; // 02d = pad with leading zeros to 2 digits
//                    lblDate.textAlignment = NSTextAlignmentCenter;
//                    }
//                else if (component == 2) // Minutes
//                    {
//                    int max = (int)[self.calendar maximumRangeOfUnit:NSMinuteCalendarUnit].length;
//                    [lblDate setText:[NSString stringWithFormat:@"%02d",(row % max)]]; lblDate.textAlignment = NSTextAlignmentLeft; }
//        return lblDate;
//            }

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (pickerView.tag == 0)
    {return self.numberOfPhotosArray.count;}
    else {return self.locationArray.count;}
}

//Returns the highlighted value to the UI
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if (pickerView.tag == 0){return [self.numberOfPhotosArray objectAtIndex:row];}
    else {return [self.locationArray objectAtIndex:row];}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    if (pickerView.tag == 0)
    {
        self.numPhotos = [[self pickerView:_InputNumberOfPhotos titleForRow:[_InputNumberOfPhotos selectedRowInComponent:0] forComponent:0]	integerValue];}
    else {
        self.location = [self pickerView:_InputLocation titleForRow:[_InputLocation selectedRowInComponent:0] forComponent:0];}

    //    self.numPhotos = [[self pickerView:_InputNumberOfPhotos titleForRow:[_InputNumberOfPhotos selectedRowInComponent:0] forComponent:0]	integerValue];}
}

 #pragma mark - Prepare for Segue
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     CollectionViewController *collectionViewController = (CollectionViewController *)segue.destinationViewController;
     collectionViewController.numPhotos = self.numPhotos;
 }

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Falbumize:(UIButton *)sender {
}
@end
