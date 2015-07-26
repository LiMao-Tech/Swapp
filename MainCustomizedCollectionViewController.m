//
//  MainCustomizedCollectionViewController.m
//  Swapp
//
//  Created by Yumen Cao on 7/25/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//



#import "AppDelegate.h"
#import "CommonImports.h"
#import "NetworkCheck.h"
#import "SWRevealViewController.h"

#import "MainCustomizedCollectionViewController.h"
#import "MainCollectionViewFlowLayout.h"
#import "MainCollectionViewCell.h"


@interface MainCustomizedCollectionViewController ()

@end

NSString *mainCellIdentifier = @"MainCell";
NSString *mainCellXibName = @"MainCollectionViewCell";

NSString *hostName = @"http://www.code-desire.com.tw";
NSString *cloudAddrYumen = @"http://www.code-desire.com.tw/LiMao/Barter/Images/";

@implementation MainCustomizedCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Creating the collection view with customized layout
    MainCollectionViewFlowLayout * layout = [[MainCollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 20.f;
    layout.minimumLineSpacing = 20.f;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(10.f, 20.f, 10.f, 20.f);
    
    // Bigger items for iPad
    // layout.itemSize = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? CGSizeMake(120, 120) : CGSizeMake(80, 80);
    
    // Allocate and configure a collection view
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.bounces = YES;
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.collectionView = collectionView;
    
    // Add to view
    [self.view addSubview:collectionView];
    
    
    // setup sidebar menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    // self.clearsSelectionOnViewWillAppear = NO;
    [self setTitle:@"热门"];
    
    // Register Xib
    UINib * mainCell = [UINib nibWithNibName:mainCellXibName bundle:nil];
    [self.collectionView registerNib:mainCell forCellWithReuseIdentifier:mainCellIdentifier];
    
    self.networkManager = [Reachability reachabilityForInternetConnection];
    self.networkManager.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
    };
    [self.networkManager startNotifier];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar.topItem setTitle: @"热门"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"Did receive Memory warning called");
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
    NSLog(@"section: %ld", indexPath.section);
    
    cellWidth = APPDELEGATE.SCREEN_WIDTH /3 - 3;
    cellHeight = APPDELEGATE.SCREEN_WIDTH/3 - 3;
    
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
        else {
            NSLog(@"Waiting for image.");
        }
    }];
    
    NetworkStatus status = [self.networkManager currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        /*
        if (!self.isUserWarned) {
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"无网络连接"
                                                               message:@"请开启手机信号或连接到WiFi"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            [self setIsUserWarned:true];
            
        }
         */
        
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        NSLog(@"YES. Reachable by WiFi.");
    }
    else if (status == ReachableViaWWAN)
    {
        
        //3G
        NSLog(@"YES. Reachable by WWAN.");
    }
    
    /*
     NSString * status = [self.networkManager currentReachabilityString];
     NSLog(@"%@", status);
     
     if ([self.networkManager isReachable]) {
     NSLog(@"YES. Reachable.");
     }
     else {
     NSLog(@"No. Not Reachable at All.");
     }
     
     if([self.networkManager isReachableViaWiFi]) {
     NSLog(@"YES. Reachable by WiFi.");
     }
     else {
     NSLog(@"No. Not Reachable by WiFi.");
     }
     
     if([self.networkManager isReachableViaWWAN]) {
     NSLog(@"YES. Reachable by WWAN.");
     }
     else {
     NSLog(@"No. Not Reachable by WWAN.");
     }
     */
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
}

 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }


@end
