//
//  MNKPDFThumbsViewController.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 04.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFThumbsViewController.h"
#import "MNKReordableLayout.h"
#import "MNKPDFDocument.h"
#import "MNKPDFThumbCell.h"
#import "MNKPDFThumbsMainToolbar.h"
#import "MNKPDFConstants.h"

@interface MNKPDFThumbsViewController ()
<MNKReordableLayoutDelegate, MNKReordableLayoutDataSource,
MNKPDFThumbsMainToolbarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) MNKPDFDocument *document;
@property (nonatomic, assign) CGPDFDocumentRef documentRef;

@property (nonatomic, strong) MNKPDFThumbsMainToolbar *mainToolbar;

@end

@implementation MNKPDFThumbsViewController

- (instancetype)initWithDocument:(MNKPDFDocument *)document {
    
    self = [super init];
    if (self) {
        _document = document;
        _documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)_document.fileURL);
    }
    return self;
}

- (void)dealloc {
    
    CGPDFDocumentRelease(_documentRef);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect toolbarRect = self.view.bounds;
    toolbarRect.size.height = MAIN_TOOLBAR_HEIGHT;
    if (![self prefersStatusBarHidden]) {
        toolbarRect.size.height += STATUS_BAR_HEIGHT;
    }
    
    _mainToolbar = [[MNKPDFThumbsMainToolbar alloc] initWithFrame:toolbarRect];
    _mainToolbar.delegate = self;
    [self.view addSubview:_mainToolbar];
    
    CGRect collectionViewRect = CGRectMake(0.0f, _mainToolbar.bounds.size.height,
                                           self.view.bounds.size.width,
                                           self.view.bounds.size.height - toolbarRect.size.height);
    MNKReordableLayout *layout = [[MNKReordableLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewRect
                                         collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[MNKPDFThumbCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_collectionView];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [_collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark – MNKReordableLayoutDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _document.pageCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger thumbs;
    UIDeviceOrientation currentOrientation = [[UIDevice currentDevice] orientation];
    if (currentOrientation == (UIDeviceOrientationLandscapeLeft | UIDeviceOrientationLandscapeRight)) {
        thumbs = THUMBS_IN_ROW_LANDSCAPE;
    } else {
        thumbs = THUMBS_IN_ROW_PORTRAIT;
    }
    CGFloat width = (NSUInteger)(_collectionView.bounds.size.width - (thumbs + 1) * 8) / thumbs;
    CGFloat height = width * 1.25;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(8.0f, 8.0f, 8.0f, 8.0f);
}

- (BOOL)collectionView:(UICollectionView *)collectionView allowMoveAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView reorderingItemAlphaInSection:(NSInteger)section {
    
    return 0.0f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MNKPDFThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                      forIndexPath:indexPath];
    NSUInteger pageNumber = [(NSNumber *)_document.pages[indexPath.row] integerValue];
    NSUInteger pageAngle = [_document.angles[indexPath.row] integerValue];
    
    CGPDFPageRef page = CGPDFDocumentGetPage(_documentRef, pageNumber);
    [cell renderThumbWithDocumentGUID:_document.guid pageNumber:pageNumber
                                 page:page thumbSize:MNKPDFThumbSizeMedium];
    cell.angle = pageAngle;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate thumbsViewController:self pageTapped:
     indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath
    didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    [_document.pages exchangeObjectAtIndex:atIndexPath.row withObjectAtIndex:toIndexPath.row];
    [_document.angles exchangeObjectAtIndex:atIndexPath.row withObjectAtIndex:toIndexPath.row];
    NSLog(@"Indexes: %i <-> %i", (int)atIndexPath.row, (int)toIndexPath.row);
    NSLog(@"Pages: %@ <-> %@", _document.pages[atIndexPath.row],
        _document.pages[toIndexPath.row]);
}

#pragma mark – MNKPDFThumbsMainToolbarDelegate methods

- (void)tappedInToolbar:(MNKPDFThumbsMainToolbar *)toolbar doneButton:(UIButton *)button {
    
    [self.delegate dismissThumbsViewController:self];
}

- (void)tappedInToolbar:(MNKPDFThumbsMainToolbar *)toolbar showControl:(UISegmentedControl *)control { }

@end
