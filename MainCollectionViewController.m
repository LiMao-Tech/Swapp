//
//  MainCollectionViewController.m
//  Swapp
//
//  Created by Gawain Tsao on 7/9/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import "MainCollectionViewController.h"
#import "BarterTableViewController.h"
#import "CommonImports.h"

@interface MainCollectionViewController ()

@end

NSString *mainCellIdentifier = @"MainCell";
NSString *mainCellXibName = @"MainCollectionViewCell";

NSString *cloudAddrYumen = @"http://www.code-desire.com.tw/LiMao/Barter/Images/";
@implementation MainCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setTitle:@"热门"];
    UINib * mainCell = [UINib nibWithNibName:mainCellXibName bundle:nil];
    [self.collectionView registerNib:mainCell forCellWithReuseIdentifier:mainCellIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar.topItem setTitle: @"热门"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 20;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellWidth;
    CGFloat cellHeight;
    NSLog(@"row: %ld", indexPath.row);
    
    if (indexPath.row== 0) {
        cellWidth =[[UIScreen mainScreen] bounds].size.width*2/3;
        cellHeight = [[UIScreen mainScreen] bounds].size.width*2/3;
    }
    else {
        cellWidth =[[UIScreen mainScreen] bounds].size.width/3 - 3;
        cellHeight = [[UIScreen mainScreen] bounds].size.width/3 - 3;
    }
    return CGSizeMake(cellWidth, cellHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:mainCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString *cellImageUrlStr = [NSString stringWithFormat:@"%@%ld.png", cloudAddrYumen, (long)indexPath.row];
    NSURL * cellImageUrl = [NSURL URLWithString:cellImageUrlStr];
    
    
    [self downloadImageWithURL:cellImageUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            [cell.mainCellImage setImage: image];
  
            // cache the image for use later (when scrolling up)
        }
    }];
    
    /*
    
    NSData *fetchedData = [[NSData alloc] initWithContentsOfURL:cellImageUrl];
    
    UIImage *fetchedImage = [UIImage imageWithData:fetchedData];
    cell.mainCellImage.image = fetchedImage;
    */
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
