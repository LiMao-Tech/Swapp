//
//  MainCollectionViewController.h
//  Swapp
//
//  Created by Gawain Tsao on 7/9/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)

@interface MainCollectionViewController : UICollectionViewController<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *wishButton;

@property (strong) Reachability * networkManager;
@property bool isUserWarned;
@property NSInteger cellSelected;

@end
