//
//  MainCustomizedCollectionViewController.h
//  Swapp
//
//  Created by Yumen Cao on 7/25/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface MainCustomizedCollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (nonatomic, weak) UICollectionView * collectionView;
@property (strong) Reachability * networkManager;

@end
