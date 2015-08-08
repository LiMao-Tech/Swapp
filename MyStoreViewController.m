//
//  MyStoreViewController.m
//  Swapp
//
//  Created by Yumen Cao on 7/29/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonImports.h"
#include "Reachability.h"
#import "SWRevealViewController.h"

#import "MyStoreViewController.h"
#import "StoreCollectionViewCell.h"

#define MYINFOMENUBUTTONWIDTH (APPDELEGATE.SCREEN_WIDTH/4)
#define STOREMENUBUTTONWIDTH (APPDELEGATE.SCREEN_WIDTH/2)

@interface MyStoreViewController ()

@end

static NSString * const storeCellIdentifier = @"StoreCell";
static NSString * const storeCellXibName = @"StoreCollectionViewCell";

@implementation MyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup sidebar menu
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sideBarButton setTarget: self.revealViewController];
        [self.sideBarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // load profile image
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MENUHEIHT*2, MENUHEIHT*2)];
    self.profileImageView.layer.cornerRadius = 25;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.image = [UIImage imageNamed:@"bellucci.jpg"];
    
    // add user name
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(APPDELEGATE.SCREEN_WIDTH/2, MENUHEIHT/2, APPDELEGATE.SCREEN_WIDTH/2, MENUHEIHT)];
    self.userNameLabel.text = @"Monica Bellucci";
    
    // myinfo
    NSArray * infoItemArray = @[@{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"S Coin",
                                    TITLEWIDTH:[NSNumber numberWithFloat:MYINFOMENUBUTTONWIDTH]
                                },
                                @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"我的交换",
                                    TITLEWIDTH:[NSNumber numberWithFloat:MYINFOMENUBUTTONWIDTH]
                                },
                                 @{NOMALKEY: @"normal.png",
                                   HEIGHTKEY:@"helight.png",
                                   TITLEKEY:@"我的评价",
                                   TITLEWIDTH:[NSNumber numberWithFloat:MYINFOMENUBUTTONWIDTH]
                                },
                                 @{NOMALKEY: @"normal.png",
                                   HEIGHTKEY:@"helight.png",
                                   TITLEKEY:@"我的关注",
                                   TITLEWIDTH:[NSNumber numberWithFloat:MYINFOMENUBUTTONWIDTH]
                                }
                                  ];
    
    // init my info menu
    self.infoMenu = [[HorizontalMenu alloc] initWithFrame:CGRectMake(0, MENUHEIHT*2, APPDELEGATE.SCREEN_WIDTH, MENUHEIHT) ButtonItems:infoItemArray];
    self.infoMenu.delegate = self;
    
    // store menu info
    NSArray * storeMenuItemArray = @[@{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"我的物品",
                                    TITLEWIDTH:[NSNumber numberWithFloat:STOREMENUBUTTONWIDTH]
                                    },
                                  @{NOMALKEY: @"normal.png",
                                    HEIGHTKEY:@"helight.png",
                                    TITLEKEY:@"我的愿望",
                                    TITLEWIDTH:[NSNumber numberWithFloat:STOREMENUBUTTONWIDTH]
                                    }
                                  ];
    

    // init store menu
    self.storeMenu = [[HorizontalMenu alloc] initWithFrame:CGRectMake(0, MENUHEIHT*3, self.view.frame.size.width, MENUHEIHT) ButtonItems:storeMenuItemArray];
    self.storeMenu.delegate = self;
    
    // init the layout
    LMCollectionViewLayout * layout = [[LMCollectionViewLayout alloc] init];
    layout.delegate = self;
    layout.blockPixels = CGSizeMake(75,75);
    
    // init storeView
    self.storeView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, MENUHEIHT*4, APPDELEGATE.SCREEN_WIDTH, APPDELEGATE.SCREEN_HEIGHT- MENUHEIHT*4) collectionViewLayout:layout];
    
    self.storeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.storeView.backgroundColor = [UIColor whiteColor];
    self.storeView.bounces = YES;
    self.storeView.alwaysBounceVertical = YES;
    self.storeView.delegate = self;
    self.storeView.dataSource = (id)self;

    // Register Xib for storeView
    UINib * storeCell = [UINib nibWithNibName:storeCellXibName bundle:nil];
    [self.storeView registerNib:storeCell forCellWithReuseIdentifier:storeCellIdentifier];
    
    // default to the first tab
    UIImageView * imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, APPDELEGATE.SCREEN_WIDTH, MENUHEIHT*3)];
    
    
    [imageView setBackgroundColor:[UIColor yellowColor]];
    [self.storeMenu clickButtonAtIndex:0];
    
    // add all views in order
    [self.view addSubview: imageView];
    [self.view addSubview: self.profileImageView];
    [self.view addSubview: self.userNameLabel];
    [self.view addSubview: self.infoMenu];
    [self.view addSubview: self.storeMenu];
    [self.view addSubview: self.storeView];
    
    [self.storeView reloadData];

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

#pragma mark - UICollectionView Datasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StoreCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:storeCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [self colorForNumber:indexPath.row];
    
    return cell;
}


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 25;
}

#pragma mark helpers

- (UIColor*) colorForNumber:(NSInteger)num {
    return [UIColor colorWithHue:(num * 77 % 255)/255.f saturation:1.f brightness:1.f alpha:1.f];
}

@end
