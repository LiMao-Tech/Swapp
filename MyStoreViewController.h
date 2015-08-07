//
//  MyStoreViewController.h
//  Swapp
//
//  Created by Yumen Cao on 7/29/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HorizontalMenu.h"
#import "LMCollectionViewLayout.h"

@interface MyStoreViewController : UIViewController <HorizontalMenuDelegate, LMCollectionViewLayoutDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@property (strong, nonatomic) UIImageView * profileImageView;
@property (strong, nonatomic) UILabel * userNameLabel;
@property (strong, nonatomic) HorizontalMenu * infoMenu;
@property (strong, nonatomic) HorizontalMenu * storeMenu;

@property (strong, nonatomic) UICollectionView * storeView;

@end
