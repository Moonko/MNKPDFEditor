//
//  MNKReordableLayout.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 04.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNKReordableLayout;

@protocol MNKReordableLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional
- (void)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath;
- (void)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (BOOL)collectionView:(UICollectionView *)collectionView allowMoveAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath;

- (void)collectionView:(UICollectionView *)collectionView collectionViewLayout:(MNKReordableLayout *)layout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView collectionViewLayout:(MNKReordableLayout *)layout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView collectionViewLayout:(MNKReordableLayout *)layout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView collectionViewLayout:(MNKReordableLayout *)layout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol MNKReordableLayoutDataSource <UICollectionViewDataSource>

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

@optional

- (CGFloat)collectionView:(UICollectionView *)collectionView reorderingItemAlphaInSection:(NSInteger)section;
- (UIEdgeInsets)scrollTrigerEdgeInsetsInCollectionView:(UICollectionView *)collectionView;
- (UIEdgeInsets)scrollTrigerPaddingInCollectionView:(UICollectionView *)collectionView;
- (CGFloat)scrollSpeedValueInCollectionView:(UICollectionView *)collectionView;

@end

@interface MNKReordableLayout : UICollectionViewFlowLayout
<UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<MNKReordableLayoutDelegate> delegate;
@property (nonatomic, weak) id<MNKReordableLayoutDataSource> dataSource;

@property (nonatomic, assign) UIEdgeInsets trigerInsets;
@property (nonatomic, assign) UIEdgeInsets trigerPadding;
@property (nonatomic, assign) CGFloat scrollSpeedValue;

- (void)cancelDrag;

@end

@interface MNKCellFakeView: UIView

@property (nonatomic, weak) UICollectionViewCell *cell;
@property (nonatomic, strong) UIImageView *cellFakeImageView;
@property (nonatomic, strong) UIImageView *cellFakeHighlightedView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGRect cellFrame;
@property (nonatomic, assign) CGPoint originalCenter;

- (instancetype)initWithCell:(UICollectionViewCell *)cell;
- (void)changeBoundsIfNeeded:(CGRect)bounds;
- (void)pushForwardView;
- (void)pushBackView:(void(^)())completion;

@end
