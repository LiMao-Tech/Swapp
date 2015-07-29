//
//  LMCollectionViewController.m
//  Swapp
//
//  Created by Yumen Cao on 7/26/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "CommonImports.h"

#import "LMCollectionViewController.h"
#import "MainCollectionViewCell.h"


@interface LMCollectionViewController()

@end

@implementation LMCollectionViewController

NSUInteger num = 0;

enum CELLSIZE {
    STDSIZE = 1,
    LSIZE = 2
};

NSString *mainCellIdentifier = @"MainCell";
NSString *mainCellXibName = @"MainCollectionViewCell";

NSString *hostName = @"http://www.code-desire.com.tw";
NSString *cloudAddrYumen = @"http://www.code-desire.com.tw/LiMao/Barter/Images/";

- (void)viewDidLoad {
    [super viewDidLoad];
        [self datasInit];
    // init the layout
    LMCollectionViewLayout * layout = [[LMCollectionViewLayout alloc] init];
    layout.delegate = self;
    layout.blockPixels = CGSizeMake(75,75);
    
    // init the view
    self.lmCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.lmCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.lmCollectionView.backgroundColor = [UIColor whiteColor];
    self.lmCollectionView.bounces = YES;
    self.lmCollectionView.alwaysBounceVertical = YES;
    self.lmCollectionView.delegate = self;
    self.lmCollectionView.dataSource = (id)self;
    
    // Register Xib
    UINib * mainCell = [UINib nibWithNibName:mainCellXibName bundle:nil];
    [self.lmCollectionView registerNib:mainCell forCellWithReuseIdentifier:mainCellIdentifier];
    
    // Add to view
    [self.view addSubview:self.lmCollectionView];
    
    // setup sidebar menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    

    [self.lmCollectionView reloadData];
    
    NSLog(@"Sections: %lu", self.lmCollectionView.numberOfSections);
}
- (void)datasInit {
    num = 0;
    self.numbers = [@[] mutableCopy];
    self.numberWidths = @[].mutableCopy;
    self.numberHeights = @[].mutableCopy;
    
    for(; num < 15; num++) {
        [self.numbers addObject:@(num)];
        [self.numberWidths addObject:@([self randomLength])];
        [self.numberHeights addObject:@([self randomLength])];
    }
    
    
}
- (void) viewDidAppear:(BOOL)animated {
    [self.lmCollectionView reloadData];
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
/*
- (IBAction)remove:(id)sender {
    
    if (!self.numbers.count) {
        return;
    }

    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *toRemove = [visibleIndexPaths objectAtIndex:(arc4random() % visibleIndexPaths.count)];
    [self removeIndexPath:toRemove];
}

- (IBAction)refresh:(id)sender {
    [self datasInit];
    [self.collectionView reloadData];
}

- (IBAction)add:(id)sender {
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    if (visibleIndexPaths.count == 0) {
        [self addIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return;
    }
    NSUInteger middle = (NSUInteger)floor(visibleIndexPaths.count / 2);
    NSIndexPath *toAdd = [visibleIndexPaths firstObject];[visibleIndexPaths objectAtIndex:middle];
    [self addIndexPath:toAdd];
}
 */

- (UIColor*) colorForNumber:(NSNumber*)num {
    return [UIColor colorWithHue:((19 * num.intValue) % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self magnifyCellAtIndexPath:indexPath];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"items: %lu", self.numbers.count);
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
       NSLog(@"Returning a Cell!");
    MainCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:mainCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];
    
    UILabel* label = (id)[cell viewWithTag:5];
    if(!label) label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.tag = 5;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%@", self.numbers[indexPath.row]];
    label.backgroundColor = [UIColor clearColor];

    // Configure the cell
    NSString *cellImageUrlStr = [NSString stringWithFormat:@"%@%ld.png", cloudAddrYumen, (long)indexPath.row];
    NSURL * cellImageUrl = [NSURL URLWithString:cellImageUrlStr];
    
    
    [self downloadImageWithURL:cellImageUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            [cell.mainCellImage setImage: image];
            
            // cache the image for use later (when scrolling up)
        }
        else {
            NSLog(@"Waiting for image.");
        }
    }];

    return cell;
}


#pragma mark – LMCollectionViewLayoutDelegate


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row >= self.numbers.count) {
        NSLog(@"Asking for index paths of non-existant cells!! %ld from %lu cells", (long)indexPath.row, (unsigned long)self.numbers.count);
    }
    
    CGFloat width = [[self.numberWidths objectAtIndex:indexPath.row] floatValue];
    CGFloat height = [[self.numberHeights objectAtIndex:indexPath.row] floatValue];
    return CGSizeMake(width, height);
    
    //    if (indexPath.row % 10 == 0)
    //        return CGSizeMake(3, 1);
    //    if (indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 1);
    //    else if (indexPath.row % 7 == 0)
    //        return CGSizeMake(1, 3);
    //    else if (indexPath.row % 8 == 0)
    //        return CGSizeMake(1, 2);
    //    else if(indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 2);
    //    if (indexPath.row == 0) return CGSizeMake(5, 5);
    //
    //    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - Helper methods

- (void)addIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.numbers.count) {
        return;
    }
    
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.lmCollectionView performBatchUpdates:^{
        NSInteger index = indexPath.row;
        [self.numbers insertObject:@(++num) atIndex:index];
        [self.numberWidths insertObject:@(STDSIZE) atIndex:index];
        [self.numberHeights insertObject:@(STDSIZE) atIndex:index];
        
        [self.lmCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

- (void)magnifyCellAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.numbers.count || indexPath.row > self.numbers.count) return;
    
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.lmCollectionView performBatchUpdates:^{
        NSInteger index = indexPath.row;
        
        // [self.numbers removeObjectAtIndex:index];
        [self.numberWidths removeObjectAtIndex:index];
        [self.numberHeights removeObjectAtIndex:index];
        
        [self.lmCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        
        //  [self.numbers insertObject:@(++num) atIndex:index];
        [self.numberWidths insertObject:@(LSIZE) atIndex:index];
        [self.numberHeights insertObject:@(LSIZE) atIndex:index];
        
        [self.lmCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        /*
         NSUInteger width = self.numberWidths[index];
         NSUInteger height = self.numberHeights[index];
         
         [self.numberWidths replaceObjectAtIndex:index withObject:@(width*2)];
         [self.numberHeights replaceObjectAtIndex:index withObject:@(height*2)];
         */
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

#pragma mark helpers

- (NSUInteger)randomLength
{
    return 1;
}

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

@end
