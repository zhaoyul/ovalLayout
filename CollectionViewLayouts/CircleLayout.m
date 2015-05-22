//
//  CircleLayout.m
//  CollectionViewLayouts
//
//  Created by Ramon Bartl on 25.05.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "CircleLayout.h"

/* Custom Layout need to implement the following methods

   collectionViewContentSize
   layoutAttributesForElementsInRect:
   layoutAttributesForItemAtIndexPath:
   layoutAttributesForSupplementaryViewOfKind:atIndexPath: (if your layout supports supplementary views)
   layoutAttributesForDecorationViewOfKind:atIndexPath: (if your layout supports decoration views)
   shouldInvalidateLayoutForBoundsChange:
 
 The core laout process is done in the following order:
 
   1. The `prepareLayout` method is your chance to do the up-front calculations needed to provide layout information.
   2. The `collectionViewContentSize` method is where you return the overall size of the entire content area based on your initial calculations.
   3. The `layoutAttributesForElementsInRect:` method returns the attributes for cells and views that are in the specified rectangle.
 */

#define ITEM_SIZE 20

@implementation CircleLayout {
    CGSize size;
    NSMutableArray *insertPaths, *deletePaths;
    CGPoint incomingPoint;
    CGPoint outgoingPoint;
}


- (void)prepareLayout
{
    [super prepareLayout];
    NSLog(@"CircleLayout::prepareLayout");
    
    _offset +=  M_PI/2;

    // content area is exactly our viewble area
    size = self.collectionView.frame.size;

    // we only support one section
    _cellCountForSection0 = [self.collectionView numberOfItemsInSection:0];
    _cellCountForSection1 = [self.collectionView numberOfItemsInSection:1];

    // the center point of our viewable area
    _center = CGPointMake(size.width/2, size.height/2);

    // the circle radius
    _radius = MIN(size.width, size.height)/2.5;
    
    incomingPoint = CGPointMake(_center.x + _radius * cosf(M_PI/5),
                                _center.y + _radius * 0.3 * sinf(M_PI/5));
    outgoingPoint = CGPointMake(_center.x + _radius * cosf(M_PI/5 + M_PI),
                                _center.y + _radius * 0.3 * sinf(M_PI/5 + M_PI));
}

- (CGSize)collectionViewContentSize
{
    NSLog(@"CircleLayout::collectionViewContentSize:size %.1fx%.1f", size.width, size.height);
    return size;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"CircleLayout::layoutAttributesForItemAtIndexPath:indexPath [%d, %d]", indexPath.section, indexPath.row);
    // instanciate the layout attributes object
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes
                                                        layoutAttributesForCellWithIndexPath:indexPath];
    if (indexPath.section == 0) {

        attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
        attributes.center = CGPointMake(_center.x + _radius *
                                        cosf( M_PI/5 + self.offset + M_PI/2 * indexPath.item),
                                        _center.y + _radius * 0.3 *
                                        sinf( M_PI/5 + self.offset + M_PI/2 * indexPath.item));
    } else {
        attributes.size = CGSizeMake(200, 200);
        attributes.center = _center;
    }
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"CircleLayout::layoutAttributesForElementsInRect");
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger i=0; i < self.cellCountForSection0; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    for (NSInteger i=0; i < self.cellCountForSection1; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:1];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    return attributes;
}

- (void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    NSLog(@"CircleLayout::prepareForCollectionViewUpdates: items=%@", updateItems);


    // remember inserted and deleted index paths for separate animations
    insertPaths = @[].mutableCopy;
    deletePaths = @[].mutableCopy;

    for (UICollectionViewUpdateItem *item in updateItems) {
        if (item.updateAction == UICollectionUpdateActionInsert) {
            [insertPaths addObject:item.indexPathAfterUpdate];
        } else if (item.updateAction == UICollectionUpdateActionDelete) {
            [deletePaths addObject:item.indexPathBeforeUpdate];
        }
    }

    NSLog(@"insertPaths=%@, deletePaths=%@", insertPaths, deletePaths);
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];

    // begin-transition attributes for inserted objects
    if ([insertPaths containsObject:itemIndexPath]) {
        attributes.alpha = 0.0;
        attributes.center = incomingPoint;
//        attributes.size = CGSizeMake(ITEM_SIZE * 2, ITEM_SIZE * 2);
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
        NSLog(@"Appearing layout for **inserted** object [%ld, %ld] set", (long)itemIndexPath.section, (long)itemIndexPath.row);
    } else {
        // all other objects
        NSLog(@"Appearing layout for other object [%ld, %ld] set", (long)itemIndexPath.section, (long)itemIndexPath.row);
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];

    // end-transition attributes for deleted objects
    if ([deletePaths containsObject:itemIndexPath]) {
        attributes.alpha = 0.0;
        attributes.center = outgoingPoint;
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
        NSLog(@"Disappearing layout for **deleted** object [%d, %d] set", itemIndexPath.section, itemIndexPath.row);
    } else {
        // all other objects
        NSLog(@"Disappearing layout for other object [%d, %d] set", itemIndexPath.section, itemIndexPath.row);
    }

    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end