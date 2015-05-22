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
#import "ImageCell.h"


@implementation ViewController {
    UICollectionViewCell *_cell1;
    NSInteger sectionNo;
}

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
    sectionNo = 0;
    // register our custom Cell
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"ImageCell"];

    // add gesture recognizers
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.collectionView addGestureRecognizer:tapRecognizer];

    // set background color
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    [self.collectionView reloadData];
}

# pragma mark - UICollectionViewDataSource methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.cellCount;
    } else if (section == 1){
        return sectionNo;
    } else {
        NSAssert(NO, @"shoule never hit here");
        return 0;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"1.png", @"2.png", @"3.png", @"4.png"];
    UICollectionViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        if (indexPath.item == 0) {
            cell.backgroundColor = [UIColor redColor];
        }
        if (indexPath.item == 1) {
            cell.backgroundColor = [UIColor blueColor];
        }
        if (indexPath.item == 2) {
            cell.backgroundColor = [UIColor yellowColor];
        }

    } else if( indexPath.section == 1 ){
        ImageCell *imgCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
        imgCell.img = (UIImage*)[UIImage imageNamed:array[0]];
        
        cell = imgCell;
    } else {
        NSAssert(NO, @"something goes wrong");
    }
    
    return cell;
}

# pragma mark - gesture recognizers

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    NSLog(@"ViewController:handleTapGesture");

    if (sender.state == UIGestureRecognizerStateEnded) {
//        sectionNo -= 1;
//        [self.collectionView performBatchUpdates:^{
//            [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]]];
//        }completion:^(BOOL fin){
//            sectionNo += 1;
//            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:1]]];
//        }];
        [self.collectionView performBatchUpdates:nil completion:nil];
    }
}


@end