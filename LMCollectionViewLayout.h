//
//  LMCollectionViewLayout.h
//  Swapp
//
//  Created by Yumen Cao on 7/26/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LMCollectionViewLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath; // defaults to 1x1

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath; // defaults to uiedgeinsetszero
@end

@interface LMCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) IBOutlet NSObject<LMCollectionViewLayoutDelegate> * delegate;
@property (nonatomic, assign) CGSize blockPixels; // defaults to 100x100

// only use this if you don't have more than 1000ish items.
// this will give you the correct size from the start and
// improve scrolling speed, at the cost of time at the beginning
@property (nonatomic) BOOL prelayoutEverything;

@end
