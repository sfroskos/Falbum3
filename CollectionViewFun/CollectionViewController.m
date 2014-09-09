//
//  ViewController.m
//  CollectionViewFun
//
//  Created by joseph hoffman on 2/20/13.
//  Copyright (c) 2013 Joe Hoffman. All rights reserved.
//

#import "CollectionViewController.h"
#import "Cell.h"
#import "ImageDetailViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.truckImages = @[@"silverFord",@"orangeFord",@"yellowFord",@"greenFord"];
    
    self.truckDescriptions = @[@"50's Silver Ford", @"50's Orange Ford", @"70's Yellow Ford",@"50's Green Ford" ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [self.truckImages count];
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    //cell.imageView.image = [UIImage imageNamed:self.truckImages[0]];
    UIImage *truckImage = [[UIImage alloc] init];
    truckImage = [UIImage imageNamed:[self.truckImages objectAtIndex:indexPath.row]];
    cell.imageView.image = truckImage;
    return cell;
}

#pragma mark - Prepare for Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
 
    ImageDetailViewController *imageDetailViewController = (ImageDetailViewController *)segue.destinationViewController;
    imageDetailViewController.truckImage = [UIImage imageNamed:[self.truckImages objectAtIndex:indexPath.row]];
    imageDetailViewController.truckLabelText = [self.truckDescriptions objectAtIndex:indexPath.row];
}
@end
