//
//  MainCollectionViewFlowLayout.h
//  Swapp
//
//  Created by Yumen Cao on 7/25/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) BOOL isBoring;

// Containers for keeping track of changing items
@property (nonatomic, strong) NSMutableArray *insertedIndexPaths;
@property (nonatomic, strong) NSMutableArray *removedIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedSectionIndices;
@property (nonatomic, strong) NSMutableArray *removedSectionIndices;

// Caches for keeping current/previous attributes
@property (nonatomic, strong) NSMutableDictionary *currentCellAttributes;
@property (nonatomic, strong) NSMutableDictionary *currentSupplementaryAttributesByKind;
@property (nonatomic, strong) NSMutableDictionary *cachedCellAttributes;
@property (nonatomic, strong) NSMutableDictionary *cachedSupplementaryAttributesByKind;

// Use to compute previous location of other cells when cells get removed/inserted
- (NSIndexPath*)previousIndexPathForIndexPath:(NSIndexPath*)indexPath accountForItems:(BOOL)checkItems;

@end
