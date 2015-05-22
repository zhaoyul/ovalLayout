//
//  ViewController.m
//  CollectionViewLayouts
//
//  Created by Ramon Bartl on 25.05.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "ViewController.h"

#import "CircleLayout.h"
#import "Cell.h"

@implementation ViewController

- (id)init
{
    //UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CircleLayout *layout = [[CircleLayout alloc] init];
    self = [super initWithCollectionViewLayout:layout];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat width = self.view.bounds.size.width * 2 / 2.5;
    CGFloat height = width * 0.3;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.view.bounds.size.width - width)/2, (self.view.bounds.size.height - height)/2 + 10, width, height)];
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.fillColor = nil;
    layer.strokeColor = [UIColor whiteColor].CGColor;
    [self.collectionView.layer addSublayer:layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    

    // initial count of cells
    self.cellCount = 4;

    // register our custom Cell
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];

    // add gesture recognizers
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.collectionView addGestureRecognizer:tapRecognizer];

    // set background color
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    [self.collectionView reloadData];
}

# pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

# pragma mark - gesture recognizers

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"ViewController:handleTapGesture");

    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
        NSIndexPath *tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];

        if (tappedCellPath != nil) {
            NSLog(@"ViewController:handleTapGesture: REMOVE CELL AT [%d, %d]", tappedCellPath.section, tappedCellPath.row);
            self.cellCount -= 1;
            [self.collectionView performBatchUpdates:^{
                [self.collectionView deleteItemsAtIndexPaths:@[tappedCellPath]];
            } completion:nil];
        } else {
            self.cellCount += 1;
            [self.collectionView performBatchUpdates:^{
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                NSLog(@"ViewController:handleTapGesture: ADD CELL AT [0, 0]");
                [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            } completion:nil];
        }
    }
}


@end