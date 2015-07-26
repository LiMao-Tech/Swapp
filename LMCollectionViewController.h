//
//  LMCollectionViewController.h
//  Swapp
//
//  Created by Yumen Cao on 7/26/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMCollectionViewLayout.h"

@interface LMCollectionViewController : UIViewController <LMCollectionViewLayoutDelegate> {
    BOOL isAnimating;
}
@property (strong, nonatomic) UICollectionView * lmCollectionView;
@property (nonatomic) NSMutableArray* numbers;
@property (nonatomic) NSMutableArray* numberWidths;
@property (nonatomic) NSMutableArray* numberHeights;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

@end
