//
//  MNKReordableLayout.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 04.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKReordableLayout.h"

typedef NS_ENUM(NSInteger, MNKReordableLayoutDirection) {
    MNKReordableLayoutDirectionToTop,
    MNKReordableLayoutDirectionToEnd,
    MNKReordableLayoutDirectionIdle
};

@interface MNKReordableLayout ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) MNKReordableLayoutDirection continiousScrollDirection;
@property (nonatomic, strong) MNKCellFakeView *cellFakeView;
@property (nonatomic, assign) CGPoint panTranslation;
@property (nonatomic, assign) CGPoint fakeCellCenter;

@end

@implementation MNKReordableLayout

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"collectionView"];
}

- (void)configure {
    self.trigerInsets = UIEdgeInsetsMake(100.0f, 100.0f, 100.0f, 100.0f);
    self.trigerPadding = UIEdgeInsetsZero;
    self.scrollSpeedValue = 10.0f;
    [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:NULL];
}

- (CGFloat)scrollValueWithSpeedValue:(CGFloat)speedValue percentage:(CGFloat)percentage {
    CGFloat value = 0.0f;
    switch (_continiousScrollDirection) {
        case MNKReordableLayoutDirectionToTop: {
            value = -speedValue;
            break;
        }
        case MNKReordableLayoutDirectionToEnd: {
            value = speedValue;
            break;
        }
        case MNKReordableLayoutDirectionIdle: {
            return 0;
        }
    }
    CGFloat proofedPrecentage = MAX(MIN(1.0f, percentage), 0.0f);
    return value * proofedPrecentage;
}

- (void)setDelegate:(id<MNKReordableLayoutDelegate>)delegate {
    self.collectionView.delegate = delegate;
}

- (id<MNKReordableLayoutDelegate>)delegate {
    return (id<MNKReordableLayoutDelegate>)self.collectionView.delegate;
}

- (void)setDataSource:(id<MNKReordableLayoutDataSource>)dataSource {
    self.collectionView.dataSource = dataSource;
}

- (id<MNKReordableLayoutDataSource>)dataSource {
    return (id<MNKReordableLayoutDataSource>)self.collectionView.dataSource;
}

- (CGFloat)offsetFromTop {
    CGPoint contentOffset = self.collectionView.contentOffset;
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? contentOffset.y : contentOffset.x;
}

- (CGFloat)insetsTop {
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? contentInsets.top : contentInsets.left;
}

- (CGFloat)insetsEnd {
    UIEdgeInsets contentInsets = self.collectionView.contentInset;
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? contentInsets.bottom : contentInsets.right;
}

- (CGFloat)contentLength {
    CGSize contentSize = self.collectionView.contentSize;
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? contentSize.height : contentSize.width;
}

- (CGFloat)collectionViewLength {
    CGSize collectionViewSize = self.collectionView.bounds.size;
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? collectionViewSize.height : collectionViewSize.width;
}

- (CGFloat)fakeCellTopEdge {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? CGRectGetMinY(_cellFakeView.frame) : CGRectGetMinX(_cellFakeView.frame);
}

- (CGFloat)fakeCellEndEdge {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? CGRectGetMaxY(_cellFakeView.frame) : CGRectGetMaxX(_cellFakeView.frame);
}

- (CGFloat)trigerInsetTop {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.trigerInsets.top : self.trigerInsets.left;
}

- (CGFloat)trigerInsetEnd {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.trigerInsets.bottom : self.trigerInsets.right;
}

- (CGFloat)trigerPaddingTop {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.trigerPadding.top : self.trigerPadding.left;
}

- (CGFloat)trigerPaddingEnd {
    return self.scrollDirection == UICollectionViewScrollDirectionVertical ? self.trigerPadding.bottom : self.trigerPadding.right;
}

- (void)prepareLayout {
    [super prepareLayout];
    if ([self.dataSource respondsToSelector:@selector(scrollTrigerEdgeInsetsInCollectionView:)]) {
        self.trigerInsets = [self.dataSource scrollTrigerEdgeInsetsInCollectionView:self.collectionView];
    }
    if ([self.dataSource respondsToSelector:@selector(scrollTrigerPaddingInCollectionView:)]) {
        self.trigerPadding = [self.dataSource scrollTrigerEdgeInsetsInCollectionView:self.collectionView];
    }
    if ([self.dataSource respondsToSelector:@selector(scrollSpeedValueInCollectionView:)]) {
        self.scrollSpeedValue = [self.dataSource scrollSpeedValueInCollectionView:self.collectionView];
    }
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> * _Nullable)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attriburesArray = [super layoutAttributesForElementsInRect:rect];
    if (attriburesArray) {
        for (UICollectionViewLayoutAttributes *attribute in attriburesArray) {
            if (attribute.representedElementCategory == UICollectionElementCategoryCell) {
                if ([attribute.indexPath isEqual:_cellFakeView.indexPath]) {
                    CGFloat cellAlpha = 0.0f;
                    cellAlpha = [self.dataSource collectionView:self.collectionView reorderingItemAlphaInSection:attribute.indexPath.section];
                    attribute.alpha = cellAlpha;
                }
            }
        }
    }
    return attriburesArray;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"collectionView"]) {
        [self setUpGestureRecognizers];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setUpDisplayLink {
    if (_displayLink) {
        return;
    }
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(continiousScroll)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invalidateDisplayLink {
    _continiousScrollDirection = MNKReordableLayoutDirectionIdle;
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)beginScrollIfNeeded {
    if (!_cellFakeView) {
        return;
    }
    CGFloat offset = [self offsetFromTop];
    [self insetsTop];
    [self insetsEnd];
    CGFloat trigerInsetTop = [self trigerInsetTop];
    CGFloat trigerInsetEnd = [self trigerInsetEnd];
    CGFloat paddingTop = [self trigerPaddingTop];
    CGFloat paddingEnd = [self trigerPaddingEnd];
    CGFloat lenght = [self collectionViewLength];
    CGFloat fakeCellTopEdge = [self fakeCellTopEdge];
    CGFloat fakeCellEndEdge = [self fakeCellEndEdge];
    if (fakeCellTopEdge <= offset + paddingTop + trigerInsetTop) {
        _continiousScrollDirection = MNKReordableLayoutDirectionToTop;
        [self setUpDisplayLink];
    } else if (fakeCellEndEdge >= offset + lenght - paddingEnd - trigerInsetEnd) {
        _continiousScrollDirection = MNKReordableLayoutDirectionToEnd;
        [self setUpDisplayLink];
    } else {
        [self invalidateDisplayLink];
    }
}

- (void)moveItemIfNeeded {
    NSIndexPath *atIndexPath;
    NSIndexPath *toIndexPath;
    if (_cellFakeView) {
        atIndexPath = _cellFakeView.indexPath;
        toIndexPath = [self.collectionView indexPathForItemAtPoint:_cellFakeView.center];
    }
    if (!atIndexPath || !toIndexPath || [atIndexPath isEqual:toIndexPath]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
        if (![self.delegate collectionView:self.collectionView atIndexPath:atIndexPath canMoveToIndexPath:toIndexPath]) {
            return;
        }
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:atIndexPath:willMoveToIndexPath:)]) {
        [self.delegate collectionView:self.collectionView atIndexPath:atIndexPath willMoveToIndexPath:toIndexPath];
    }
    UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:toIndexPath];
    [self.collectionView performBatchUpdates:^{
        _cellFakeView.indexPath = toIndexPath;
        _cellFakeView.cellFrame = attribute.frame;
        [_cellFakeView changeBoundsIfNeeded:attribute.bounds];
        
        [self.collectionView deleteItemsAtIndexPaths:@[atIndexPath]];
        [self.collectionView insertItemsAtIndexPaths:@[toIndexPath]];
        
        if ([self.delegate respondsToSelector:@selector(collectionView:atIndexPath:didMoveToIndexPath:)]) {
            [self.delegate collectionView:self.collectionView atIndexPath:atIndexPath didMoveToIndexPath:toIndexPath];
        }
    }completion:nil];
}

- (void)continiousScroll {
    if (!_cellFakeView) {
        return;
    }
    CGFloat percentage = [self calculateTrigerPercentage];
    CGFloat scrollRate = [self scrollValueWithSpeedValue:self.scrollSpeedValue percentage:percentage];
    CGFloat offset = [self offsetFromTop];
    CGFloat insetTop = [self insetsTop];
    CGFloat insetEnd = [self insetsEnd];
    CGFloat length = [self collectionViewLength];
    CGFloat contentLength = [self contentLength];
    if (contentLength + insetTop + insetEnd  <= length) {
        return;
    }
    if (offset + scrollRate <= -insetTop) {
        scrollRate = -insetTop - offset;
    } else if (offset + scrollRate >= contentLength + insetEnd - length) {
        scrollRate = contentLength + insetEnd - length - offset;
    }
    [self.collectionView performBatchUpdates:^{
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            _fakeCellCenter = CGPointMake(_fakeCellCenter.x, _fakeCellCenter.y + scrollRate);
            _cellFakeView.center = CGPointMake(_cellFakeView.center.x, _fakeCellCenter.y + self.panTranslation.y);
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y + scrollRate);
        } else {
            _fakeCellCenter = CGPointMake(_fakeCellCenter.x + scrollRate, _fakeCellCenter.y);
            _cellFakeView.center = CGPointMake(_fakeCellCenter.x + _panTranslation.x, _cellFakeView.center.y);
            self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x + scrollRate, self.collectionView.contentOffset.y);
        }
    }completion:nil];
    [self moveItemIfNeeded];
}

- (CGFloat)calculateTrigerPercentage {
    if (!_cellFakeView) {
        return 0.0f;
    }
    CGFloat offset = [self offsetFromTop];
    CGFloat offsetEnd = [self offsetFromTop] + [self collectionViewLength];
    CGFloat insetTop = [self insetsTop];
    [self insetsEnd];
    CGFloat trigerInsetTop = [self trigerInsetTop];
    CGFloat trigerInsetEnd = [self trigerInsetEnd];
    [self trigerPaddingTop];
    CGFloat paddingEnd = [self trigerPaddingEnd];
    CGFloat percentage = 0.0f;
    
    if (_continiousScrollDirection == MNKReordableLayoutDirectionToTop) {
        percentage = 1.0f - (([self fakeCellTopEdge] - (offset + [self trigerPaddingTop])) / trigerInsetTop);
    } else if (_continiousScrollDirection == MNKReordableLayoutDirectionToEnd) {
        percentage = 1.0f - (((insetTop + offsetEnd - paddingEnd) - ([self fakeCellEndEdge] + insetTop)) / trigerInsetEnd);
    }
    percentage = MIN(1.0f, percentage);
    percentage = MAX(0.0f, percentage);
    return percentage;
}

- (void)setUpGestureRecognizers {
    if (!self.collectionView) {
        return;
    }
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _longPress.delegate = self;
    _panGesture.delegate = self;
    _panGesture.maximumNumberOfTouches = 1;
    NSArray *gestures = self.collectionView.gestureRecognizers;
    [gestures enumerateObjectsUsingBlock:^(UIGestureRecognizer *gesture, NSUInteger index, BOOL *stop) {
        if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gesture requireGestureRecognizerToFail:_longPress];
        }
        [self.collectionView addGestureRecognizer:_longPress];
        [self.collectionView addGestureRecognizer:_panGesture];
    }];
}

- (void)cancelDrag {
    [self cancelDragToIndexPath:nil];
}

- (void)cancelDragToIndexPath:(NSIndexPath *)indexPath {
    if (!_cellFakeView) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(collectionView:collectionViewLayout:willEndDraggingItemAtIndexPath:)]) {
        [self.delegate collectionView:self.collectionView collectionViewLayout:self willEndDraggingItemAtIndexPath:indexPath];
    }
    self.collectionView.scrollsToTop = YES;
    _fakeCellCenter = CGPointZero;
    [self invalidateDisplayLink];
    [_cellFakeView pushBackView:^{
        [_cellFakeView removeFromSuperview];
        _cellFakeView = nil;
        [self invalidateLayout];
        if ([self.delegate respondsToSelector:@selector(collectionView:collectionViewLayout:didEndDraggingItemAtIndexPath:)]) {
            [self.delegate collectionView:self.collectionView collectionViewLayout:self didEndDraggingItemAtIndexPath:indexPath];
        }
    }];

}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress {
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (_cellFakeView) {
        indexPath = _cellFakeView.indexPath;
    }
    if (!indexPath) {
        return;
    }
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            if ([self.delegate respondsToSelector:@selector(collectionView:collectionViewLayout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView collectionViewLayout:self willBeginDraggingItemAtIndexPath:indexPath];
            }
            self.collectionView.scrollsToTop = NO;
            UICollectionViewCell *currentCell = [self.collectionView cellForItemAtIndexPath:indexPath];
            _cellFakeView = [[MNKCellFakeView alloc] initWithCell:currentCell];
            _cellFakeView.indexPath = indexPath;
            _cellFakeView.originalCenter = currentCell.center;
            _cellFakeView.cellFrame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
            [self.collectionView addSubview:_cellFakeView];
            _fakeCellCenter = _cellFakeView.center;
            [self invalidateLayout];
            [_cellFakeView pushForwardView];
            
            if ([self.delegate respondsToSelector:@selector(collectionView:collectionViewLayout:didBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView collectionViewLayout:self didBeginDraggingItemAtIndexPath:indexPath];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            [self cancelDragToIndexPath:indexPath];
            break;
        }
        default:
            break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan {
    _panTranslation = [pan translationInView:self.collectionView];
    if (_cellFakeView) {
        switch (pan.state) {
            case UIGestureRecognizerStateChanged: {
                _cellFakeView.center = CGPointMake(_fakeCellCenter.x + _panTranslation.x, _fakeCellCenter.y + _panTranslation.y);
                [self beginScrollIfNeeded];
                [self moveItemIfNeeded];
                break;
            }
            case UIGestureRecognizerStateCancelled: case UIGestureRecognizerStateEnded: {
                [self invalidateDisplayLink];
                break;
            }
            default:
                break;
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (indexPath) {
        if ([self.delegate respondsToSelector:@selector(collectionView:allowMoveAtIndexPath:)]) {
            if (![self.delegate collectionView:self.collectionView allowMoveAtIndexPath:indexPath]) {
                return NO;
            }
        }
    }
    if ([gestureRecognizer isEqual:_longPress]) {
        if (self.collectionView.panGestureRecognizer.state != UIGestureRecognizerStatePossible &&
            self.collectionView.panGestureRecognizer.state != UIGestureRecognizerStateFailed) {
            return NO;
        }
    } else if ([gestureRecognizer isEqual:_panGesture]) {
        if (_longPress.state == UIGestureRecognizerStatePossible || _longPress.state == UIGestureRecognizerStateFailed) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:_longPress]) {
        if ([otherGestureRecognizer isEqual:_panGesture]) {
            return YES;
        }
    } else if ([gestureRecognizer isEqual:_panGesture]) {
        if ([otherGestureRecognizer isEqual:_longPress]) {
            return YES;
        } else {
            return NO;
        }
    } else if ([gestureRecognizer isEqual:self.collectionView.panGestureRecognizer]) {
        if (_longPress.state != UIGestureRecognizerStatePossible || _longPress.state != UIGestureRecognizerStateFailed) {
            return NO;
        }
    }
    return YES;
}

@end

#pragma mark – MNKCellFakeView

@implementation MNKCellFakeView

- (instancetype)initWithCell:(UICollectionViewCell *)cell {
    self = [super initWithFrame:cell.frame];
    if (self) {
        self.cell = cell;
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity = 0.0f;
        self.layer.shadowRadius = 5.0f;
        self.layer.shouldRasterize = NO;
        
        self.cellFakeImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.cellFakeImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.cellFakeImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.cellFakeHighlightedView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.cellFakeHighlightedView.contentMode = UIViewContentModeScaleAspectFill;
        self.cellFakeHighlightedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.cell.highlighted = YES;
        self.cellFakeHighlightedView.image = [self getCellImage];
        self.cell.highlighted = NO;
        self.cellFakeImageView.image = [self getCellImage];
        
        [self addSubview:self.cellFakeImageView];
        [self addSubview:self.cellFakeHighlightedView];
    }
    return self;
}

- (void)changeBoundsIfNeeded:(CGRect)bounds {
    if (CGRectEqualToRect(self.bounds, bounds)) {
        return;
    }
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^ {
                         self.bounds = bounds;
                     }completion:nil];
}

- (void)pushForwardView {
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.center = self.originalCenter;
                         self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                         self.cellFakeHighlightedView.alpha = 0.0f;
                         CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
                         shadowAnimation.fromValue = @(0.0f);
                         shadowAnimation.toValue = @(0.7f);
                         shadowAnimation.removedOnCompletion = NO;
                         shadowAnimation.fillMode = kCAFillModeForwards;
                         [self.layer addAnimation:shadowAnimation forKey:@"applyShadow"];
                     }completion:^(BOOL finished) {
                         [self.cellFakeHighlightedView removeFromSuperview];
                     }];
}

- (void)pushBackView:(void (^)())completion {
    [UIView animateWithDuration:0.3f delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.frame = self.cellFrame;
                         CABasicAnimation *shadowAnimation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
                         shadowAnimation.fromValue = @(0.7f);
                         shadowAnimation.toValue = @(0.0f);
                         shadowAnimation.removedOnCompletion = NO;
                         shadowAnimation.fillMode = kCAFillModeForwards;
                         [self.layer addAnimation:shadowAnimation forKey:@"removeShadow"];
                     }completion:^(BOOL finished) {
                         if (completion != nil) {
                             completion();
                         }
                     }];
}

- (UIImage *)getCellImage {
    UIGraphicsBeginImageContextWithOptions(self.cell.bounds.size, NO, [UIScreen mainScreen].scale * 2);
    [self.cell drawViewHierarchyInRect:self.cell.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
