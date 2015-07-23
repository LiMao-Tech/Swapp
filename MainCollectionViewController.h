//
//  MainCollectionViewController.h
//  Swapp
//
//  Created by Gawain Tsao on 7/9/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionViewCell.h"
#include "NetworkCheck.h"

@interface MainCollectionViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@property (strong) Reachability * networkManager;
@property bool isUserWarned;

@end
