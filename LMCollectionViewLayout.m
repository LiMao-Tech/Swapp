//
//  LMCollectionViewLayout.m
//  Swapp
//
//  Created by Yumen Cao on 7/26/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import "LMCollectionViewLayout.h"

@interface LMCollectionViewLayout ()
@property(nonatomic) CGPoint firstOpenSpace;
@property(nonatomic) CGPoint furthestBlockPoint;

// this will be a 2x2 dictionary storing nsindexpaths
// which indicate the available/filled spaces in our quilt
@property(nonatomic) NSMutableDictionary* indexPathByPosition;

// indexed by "section, row" this will serve as the rapid
// lookup of block position by indexpath.
@property(nonatomic) NSMutableDictionary* positionByIndexPath;

@property(nonatomic, assign) BOOL hasPositionsCached;

// previous layout cache.  this is to prevent choppiness
// when we scroll to the bottom of the screen - uicollectionview
// will repeatedly call layoutattributesforelementinrect on
// each scroll event.  pow!
@property(nonatomic) NSArray* previousLayoutAttributes;
@property(nonatomic) CGRect previousLayoutRect;

// remember the last indexpath placed, as to not
// relayout the same indexpaths while scrolling
@property(nonatomic) NSIndexPath* lastIndexPathPlaced;
@end

@implementation LMCollectionViewLayout

- (id)init {
    if((self = [super init]))
        [self initialize];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super initWithCoder:aDecoder]))
        [self initialize];
    
    return self;
}

- (void) initialize {
    // defaults
    self.direction = UICollectionViewScrollDirectionVertical;
    self.blockPixels = CGSizeMake(100.f, 100.f);
   

}

- (CGSize)collectionViewContentSize {

    CGRect contentRect = UIEdgeInsetsInsetRect(self.collectionView.frame, self.collectionView.contentInset);
        return CGSizeMake(CGRectGetWidth(contentRect), (self.furthestBlockPoint.y+1) * self.blockPixels.height);
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (!self.delegate) {
    return @[];
    }
    // see the comment on these properties
    if(CGRectEqualToRect(rect, self.previousLayoutRect)) {
        return self.previousLayoutAttributes;
    }
    self.previousLayoutRect = rect;
    
    
    int unrestrictedDimensionStart = rect.origin.y / self.blockPixels.height;
    int unrestrictedDimensionLength = rect.size.height / self.blockPixels.height + 1;
    int unrestrictedDimensionEnd = unrestrictedDimensionStart + unrestrictedDimensionLength;
    
    [self fillInBlocksToUnrestrictedRow:self.prelayoutEverything? INT_MAX : unrestrictedDimensionEnd];
    
    // find the indexPaths between those rows
    NSMutableSet* attributes = [NSMutableSet set];
    [self traverseTilesBetweenUnrestrictedDimension:unrestrictedDimensionStart and:unrestrictedDimensionEnd iterator:^(CGPoint point) {
        NSIndexPath* indexPath = [self indexPathForPosition:point];
        
        if(indexPath) [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        return YES;
    }];
    
    return (self.previousLayoutAttributes = [attributes allObjects]);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if([self.delegate respondsToSelector:@selector(collectionView:layout:insetsForItemAtIndexPath:)])
        insets = [[self delegate] collectionView:[self collectionView] layout:self insetsForItemAtIndexPath:indexPath];
    
    
    CGRect frame = [self frameForIndexPath:indexPath];
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = UIEdgeInsetsInsetRect(frame, insets);
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !(CGSizeEqualToSize(newBounds.size, self.collectionView.frame.size));
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    for(UICollectionViewUpdateItem* item in updateItems) {
        if(item.updateAction == UICollectionUpdateActionInsert || item.updateAction == UICollectionUpdateActionMove) {
            [self fillInBlocksToIndexPath:item.indexPathAfterUpdate];
        }
    }
}

- (void) invalidateLayout {
    [super invalidateLayout];
    
    _furthestBlockPoint = CGPointZero;
    self.firstOpenSpace = CGPointZero;
    self.previousLayoutRect = CGRectZero;
    self.previousLayoutAttributes = nil;
    self.lastIndexPathPlaced = nil;
    [self clearPositions];
}

- (void) prepareLayout {
    [super prepareLayout];
    
    if (!self.delegate) return;
    
    CGRect scrollFrame = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    
    int unrestrictedRow = 0;
    unrestrictedRow = (CGRectGetMaxY(scrollFrame) / [self blockPixels].height)+1;

    
    [self fillInBlocksToUnrestrictedRow:self.prelayoutEverything? INT_MAX : unrestrictedRow];
}

- (void) setDirection:(UICollectionViewScrollDirection)direction {
    [self invalidateLayout];
}

- (void) setBlockPixels:(CGSize)size {
    _blockPixels = size;
    [self invalidateLayout];
}

#pragma mark private methods

- (void) fillInBlocksToUnrestrictedRow:(int)endRow {
    
    // we'll have our data structure as if we're planning
    // a vertical layout, then when we assign positions to
    // the items we'll invert the axis
    
    NSInteger numSections = [self.collectionView numberOfSections];
    for (NSInteger section=self.lastIndexPathPlaced.section; section<numSections; section++) {
        NSInteger numRows = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger row = (!self.lastIndexPathPlaced? 0 : self.lastIndexPathPlaced.row + 1); row<numRows; row++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            if([self placeBlockAtIndex:indexPath]) {
                self.lastIndexPathPlaced = indexPath;
            }
            
            // only jump out if we've already filled up every space up till the resticted row
            if((self.firstOpenSpace.y) >= endRow)
                return;
        }
    }
}

- (void) fillInBlocksToIndexPath:(NSIndexPath*)path {
    
    // we'll have our data structure as if we're planning
    // a vertical layout, then when we assign positions to
    // the items we'll invert the axis
    
    NSInteger numSections = [self.collectionView numberOfSections];
    for (NSInteger section=self.lastIndexPathPlaced.section; section<numSections; section++) {
        NSInteger numRows = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger row=(!self.lastIndexPathPlaced? 0 : self.lastIndexPathPlaced.row+1); row<numRows; row++) {
            
            // exit when we are past the desired row
            if(section >= path.section && row > path.row) { return; }
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            if([self placeBlockAtIndex:indexPath]) { self.lastIndexPathPlaced = indexPath; }
            
        }
    }
}

- (BOOL) placeBlockAtIndex:(NSIndexPath*)indexPath {
    CGSize blockSize = [self getBlockSizeForItemAtIndexPath:indexPath];
    
    return ![self traverseOpenTiles:^(CGPoint blockOrigin) {
        
        // we need to make sure each square in the desired
        // area is available before we can place the square
        
        BOOL didTraverseAllBlocks = [self traverseTilesForPoint:blockOrigin withSize:blockSize iterator:^(CGPoint point) {
            BOOL spaceAvailable = (BOOL)![self indexPathForPosition:point];
            BOOL inBounds = (point.x) < [self restrictedDimensionBlockSize];
            BOOL maximumRestrictedBoundSize = (blockOrigin.x) == 0;
            
            if (spaceAvailable && maximumRestrictedBoundSize && !inBounds) {
                return YES;
            }
            
            return (BOOL) (spaceAvailable && inBounds);
        }];
        
        
        if (!didTraverseAllBlocks) { return YES; }
        
        // because we have determined that the space is all
        // available, lets fill it in as taken.
        
        [self setIndexPath:indexPath forPosition:blockOrigin];
        
        [self traverseTilesForPoint:blockOrigin withSize:blockSize iterator:^(CGPoint point) {
            [self setPosition:point forIndexPath:indexPath];
            
            self.furthestBlockPoint = point;
            
            return YES;
        }];
        
        return NO;
    }];
}

// returning no in the callback will
// terminate the iterations early
- (BOOL) traverseTilesBetweenUnrestrictedDimension:(int)begin and:(int)end iterator:(BOOL(^)(CGPoint))block {
    
    // the double ;; is deliberate, the unrestricted dimension should iterate indefinitely
    for(int unrestrictedDimension = begin; unrestrictedDimension<end; unrestrictedDimension++) {
        for(int restrictedDimension = 0; restrictedDimension<[self restrictedDimensionBlockSize]; restrictedDimension++) {
            CGPoint point = CGPointMake(restrictedDimension, unrestrictedDimension);
            
            if(!block(point)) { return NO; }
        }
    }
    
    return YES;
}

// returning no in the callback will
// terminate the iterations early
- (BOOL) traverseTilesForPoint:(CGPoint)point withSize:(CGSize)size iterator:(BOOL(^)(CGPoint))block {
    for(int col=point.x; col<point.x+size.width; col++) {
        for (int row=point.y; row<point.y+size.height; row++) {
            if(!block(CGPointMake(col, row))) {
                return NO;
            }
        }
    }
    return YES;
}

// returning no in the callback will
// terminate the iterations early
- (BOOL) traverseOpenTiles:(BOOL(^)(CGPoint))block {
    BOOL allTakenBefore = YES;
    
    // the double ;; is deliberate, the unrestricted dimension should iterate indefinitely
    for(int unrestrictedDimension = (self.firstOpenSpace.y); ; unrestrictedDimension++) {
        for(int restrictedDimension = 0; restrictedDimension<[self restrictedDimensionBlockSize]; restrictedDimension++) {
            
            CGPoint point = CGPointMake(restrictedDimension, unrestrictedDimension);
            
            if([self indexPathForPosition:point]) { continue; }
            
            if(allTakenBefore) {
                self.firstOpenSpace = point;
                allTakenBefore = NO;
            }
            
            if(!block(point)) {
                return NO;
            }
        }
    }
    
    NSAssert(0, @"Could find no good place for a block!");
    return YES;
}

- (void) clearPositions {
    self.indexPathByPosition = [NSMutableDictionary dictionary];
    self.positionByIndexPath = [NSMutableDictionary dictionary];
}

- (NSIndexPath*)indexPathForPosition:(CGPoint)point {
    
    // to avoid creating unbounded nsmutabledictionaries we should
    // have the innerdict be the unrestricted dimension
    
    NSNumber* unrestrictedPoint = @(point.y);
    NSNumber* restrictedPoint = @(point.x);
    
    return self.indexPathByPosition[restrictedPoint][unrestrictedPoint];
}

- (void) setPosition:(CGPoint)point forIndexPath:(NSIndexPath*)indexPath {
    
    // to avoid creating unbounded nsmutabledictionaries we should
    // have the innerdict be the unrestricted dimension
    
    NSNumber* unrestrictedPoint = @(point.y);
    NSNumber* restrictedPoint = @(point.x);
    
    NSMutableDictionary* innerDict = self.indexPathByPosition[restrictedPoint];
    if (!innerDict)
        self.indexPathByPosition[restrictedPoint] = [NSMutableDictionary dictionary];
    
    self.indexPathByPosition[restrictedPoint][unrestrictedPoint] = indexPath;
}


- (void) setIndexPath:(NSIndexPath*)path forPosition:(CGPoint)point {
    NSMutableDictionary* innerDict = self.positionByIndexPath[@(path.section)];
    if (!innerDict) self.positionByIndexPath[@(path.section)] = [NSMutableDictionary dictionary];
    
    self.positionByIndexPath[@(path.section)][@(path.row)] = [NSValue valueWithCGPoint:point];
}

- (CGPoint) positionForIndexPath:(NSIndexPath*)path {
    
    // if item does not have a position, we will make one!
    if(!self.positionByIndexPath[@(path.section)][@(path.row)])
        [self fillInBlocksToIndexPath:path];
    
    return [self.positionByIndexPath[@(path.section)][@(path.row)] CGPointValue];
}


- (CGRect) frameForIndexPath:(NSIndexPath*)path {
    
    CGPoint position = [self positionForIndexPath:path];
    CGSize elementSize = [self getBlockSizeForItemAtIndexPath:path];
    
    CGRect contentRect = UIEdgeInsetsInsetRect(self.collectionView.frame, self.collectionView.contentInset);

        float initialPaddingForContraintedDimension = (CGRectGetWidth(contentRect) - [self restrictedDimensionBlockSize]*self.blockPixels.width)/ 2;
        return CGRectMake(position.x*self.blockPixels.width + initialPaddingForContraintedDimension,
                          position.y*self.blockPixels.height,
                          elementSize.width*self.blockPixels.width,
                          elementSize.height*self.blockPixels.height);
}


//This method is prefixed with get because it may return its value indirectly
- (CGSize)getBlockSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize blockSize = CGSizeMake(1, 1);
    if([self.delegate respondsToSelector:@selector(collectionView:layout:blockSizeForItemAtIndexPath:)])
        blockSize = [[self delegate] collectionView:[self collectionView] layout:self blockSizeForItemAtIndexPath:indexPath];
    return blockSize;
}


// this will return the maximum width or height the quilt
// layout can take, depending on we're growing horizontally
// or vertically

- (int) restrictedDimensionBlockSize {
    
    CGRect contentRect = UIEdgeInsetsInsetRect(self.collectionView.frame, self.collectionView.contentInset);
    int size = CGRectGetWidth(contentRect) / self.blockPixels.width;
    
    if(size == 0) {
        static BOOL didShowMessage;
        if(!didShowMessage) {
            NSLog(@"%@: cannot fit block of size: %@ in content rect %@!  Defaulting to 1", [self class], NSStringFromCGSize(self.blockPixels), NSStringFromCGRect(contentRect));
            didShowMessage = YES;
        }
        return 1;
    }
    
    return size;
}

- (void) setFurthestBlockPoint:(CGPoint)point {
    _furthestBlockPoint = CGPointMake(MAX(self.furthestBlockPoint.x, point.x), MAX(self.furthestBlockPoint.y, point.y));
}

@end
