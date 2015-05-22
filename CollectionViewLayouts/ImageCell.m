//
//  ImageCell.m
//  CollectionViewLayouts
//
//  Created by Zhaoyu Li on 23/5/15.
//  Copyright (c) 2015 Ramon Bartl. All rights reserved.
//

#import "ImageCell.h"


@implementation ImageCell{
    UIImageView *_imageView;
}

-(void)setImg:(UIImage *)img{
    if (!_imageView) {
        _img = img;
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
        _imageView.image = _img;
    }
}

-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    return layoutAttributes;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}
@end
