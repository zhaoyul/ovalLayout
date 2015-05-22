//
//  Cell.m
//  CollectionViewLayouts
//
//  Created by Ramon Bartl on 25.05.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "Cell.h"

@implementation Cell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.speed =0.5;//default speed  is 1
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];

    //// cell Drawing
    UIBezierPath* cellPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [fillColor setFill];
    [cellPath fill];
}

-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [UIView setAnimationDuration:3.0];
    return layoutAttributes;
}

@end