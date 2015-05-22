//
//  ImageCell.h
//  CollectionViewLayouts
//
//  Created by Zhaoyu Li on 23/5/15.
//  Copyright (c) 2015 Ramon Bartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *img;
@property (nonatomic, getter=isActive) BOOL active;
@end
