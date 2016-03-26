//
//  MNKPDFMainPagebar.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 25.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFMainPagebar.h"
#import "MNKPDFPageTrackControl.h"
#import "MNKPDFDocument.h"
#import "MNKPDFPageNumberLabel.h"
#import "MNKPDFThumbView.h"
#import "MNKPDFConstants.h"

@interface MNKPDFMainPagebar ()

@property (nonatomic, strong) MNKPDFDocument *document;
@property (nonatomic, strong) MNKPDFPageTrackControl *trackControl;
@property (nonatomic, strong) NSMutableDictionary *thumbViews;
@property (nonatomic, strong) MNKPDFThumbView *pageThumbView;
@property (nonatomic, strong) MNKPDFPageNumberLabel *pageNumberLabel;
@property (nonatomic, strong) UIView *pageNumberView;
@property (nonatomic, assign) CGPDFDocumentRef documentRef;

@end

@implementation MNKPDFMainPagebar

- (instancetype)initWithFrame:(CGRect)frame document:(MNKPDFDocument *)document {
    self = [super initWithFrame:frame];
    if (self) {
        _document = document;
        _documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)_document.fileURL);
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        self.exclusiveTouch = YES;
        
        CGFloat pageNumberViewOriginX = (self.bounds.size.width - PAGE_NUMBER_WIDTH) * 0.5f;
        CGFloat pageNumberViewOriginY = -(PAGE_NUMBER_HEIGHT + PAGE_NUMBER_SPACE);
        CGRect pageNumberRect = CGRectMake(pageNumberViewOriginX, pageNumberViewOriginY,
                                           PAGE_NUMBER_WIDTH, PAGE_NUMBER_HEIGHT);
        _pageNumberView = [[UIView alloc] initWithFrame:pageNumberRect];
        _pageNumberView.autoresizesSubviews = NO;
        _pageNumberView.userInteractionEnabled = NO;
        _pageNumberView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleRightMargin;
        _pageNumberView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        
        CGRect textRect = CGRectInset(_pageNumberView.bounds, 4.0f, 2.0f);
        _pageNumberLabel = [[MNKPDFPageNumberLabel alloc] initWithFrame:textRect document:document];
        [_pageNumberView addSubview:_pageNumberLabel];
        
        [self addSubview:_pageNumberView];
        
        _trackControl = [[MNKPDFPageTrackControl alloc] initWithFrame:self.bounds];
        [_trackControl addTarget:self action:@selector(trackViewTouchDown:)
                forControlEvents:UIControlEventTouchDown];
        [_trackControl addTarget:self action:@selector(trackViewValueChanged:)
                forControlEvents:UIControlEventValueChanged];
        [_trackControl addTarget:self action:@selector(trackViewTouchUp:)
                forControlEvents:UIControlEventTouchUpInside];
        [_trackControl addTarget:self action:@selector(trackViewTouchUp:)
                forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_trackControl];
        
        _thumbViews = [NSMutableDictionary new];
    }
    return self;
}

- (void)updatePageThumbView:(NSUInteger)index {
    NSInteger pagesCount = _document.pageCount;
    if (pagesCount > 1) {
        CGFloat controlWidth = _trackControl.bounds.size.width;
        CGFloat usableWidth = (controlWidth - THUMB_LARGE_WIDTH);
        CGFloat stride = usableWidth / (pagesCount - 1);
        NSInteger pageThumbOriginX = stride * index;
        CGRect pageThumbRect = _pageThumbView.frame;
        if (pageThumbOriginX != pageThumbRect.origin.x) {
            pageThumbRect.origin.x = pageThumbOriginX;
            _pageThumbView.frame = pageThumbRect;
        }
    }
    NSUInteger pageNumber = [_document.pages[index] integerValue];
    if (pageNumber != _pageNumberLabel.pageNumber) {
        
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(_documentRef, pageNumber);
        [_pageThumbView renderThumbWithFrame:_pageThumbView.bounds documentGUID:_document.guid pageNumber:pageNumber page:pageRef thumbSize:MNKPDFThumbSizeSmall];
    }
}

- (void)dealloc {
    CGPDFDocumentRelease(_documentRef);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect controlRect = CGRectInset(self.bounds, 4.0f, 0.0f);
    CGFloat thumbWidth = (THUMB_SMALL_WIDTH + THUMB_SMALL_GAP);
    NSInteger thumbsCount = controlRect.size.width / thumbWidth;
    NSInteger pagesCount = _document.pageCount;
    if (thumbsCount > pagesCount) {
        thumbsCount = pagesCount;
    }
    CGFloat controlWidth = (thumbsCount * thumbWidth) - THUMB_SMALL_GAP;
    controlRect.size.width = controlWidth;
    CGFloat widthDelta = self.bounds.size.width - controlWidth;
    controlRect.origin.x = widthDelta * 0.5f;
    _trackControl.frame = controlRect;
    if (!_pageThumbView) {
        CGFloat heightDelta = controlRect.size.height - THUMB_LARGE_HEIGHT;
        NSInteger thumbOriginY = heightDelta * 0.5f;
        NSInteger thumbOriginX = 0.0f;
        CGRect thumbRect = CGRectMake(thumbOriginX, thumbOriginY,
                                      THUMB_LARGE_WIDTH, THUMB_LARGE_HEIGHT);
        _pageThumbView = [[MNKPDFThumbView alloc] initWithFrame:thumbRect];
        _pageThumbView.layer.zPosition = 1.0f;
        _pageThumbView.contentMode = UIViewContentModeScaleAspectFit;
        _pageThumbView.backgroundColor = [UIColor grayColor];
        _pageThumbView.layer.borderWidth = 1.0f;
        _pageThumbView.layer.borderColor = [UIColor blackColor].CGColor;
        [_trackControl addSubview:_pageThumbView];
    }
    [self updatePageThumbView:_document.lastOpenedPageIndex];
    NSUInteger strideThumbsCount = thumbsCount - 1;
    if (strideThumbsCount < 1) {
        strideThumbsCount = 1;
    }
    CGFloat stride = (CGFloat)pagesCount / (CGFloat)strideThumbsCount;
    CGFloat heightDelta = controlRect.size.height - THUMB_SMALL_HEIGHT;
    NSUInteger thumbOriginY = heightDelta * 0.5f;
    NSUInteger thumbOriginX = 0;
    CGRect thumbRect = CGRectMake(thumbOriginX, thumbOriginY, THUMB_SMALL_WIDTH, THUMB_SMALL_HEIGHT);
    NSMutableDictionary *thumbsToHide = [_thumbViews mutableCopy];
    for (NSUInteger thumb = 0; thumb < thumbsCount; thumb++) {
        NSUInteger page = (stride * thumb) + 1;
        if (page > pagesCount) {
            page = pagesCount;
        }
        NSNumber *key = @(page);
        MNKPDFThumbView *smallThumbView = _thumbViews[key];
        if (!smallThumbView) {
                        CGPDFPageRef pageRef = CGPDFDocumentGetPage(_documentRef, page);
            smallThumbView = [[MNKPDFThumbView alloc] initWithFrame:thumbRect];
            [smallThumbView renderThumbWithFrame:thumbRect documentGUID:_document.guid pageNumber:page page:pageRef thumbSize:MNKPDFThumbSizeSmall];
            smallThumbView.layer.borderColor = [UIColor blackColor].CGColor;
            smallThumbView.layer.borderWidth = 1.0f;
            smallThumbView.backgroundColor = [UIColor grayColor];
            smallThumbView.contentMode = UIViewContentModeScaleAspectFit;
            [_trackControl addSubview:smallThumbView];
            _thumbViews[key] = smallThumbView;
        } else {
            smallThumbView.hidden = NO;
            [thumbsToHide removeObjectForKey:key];
            if (!CGRectEqualToRect(smallThumbView.frame, thumbRect)) {
                smallThumbView.frame = thumbRect;
            }
        }
        thumbRect.origin.x += thumbWidth;
    }
    [thumbsToHide enumerateKeysAndObjectsUsingBlock:
     ^(NSNumber *key, UIImageView *object, BOOL *stop) {
         object.hidden = YES;
     }];
}

- (void)show {
    
    [self updatePagebarViews];
    [super show];
}

- (void)update {
    
    if (!self.hidden) {
        [self updatePagebarViews];
    }
}

- (void)updatePagebarViews {
    
    NSUInteger index = _document.lastOpenedPageIndex;
    _pageNumberLabel.pageNumber = index + 1;
    [self updatePageThumbView:index];
}

- (NSUInteger)trackControlPageIndex:(MNKPDFPageTrackControl *)trackControl {
    
    CGFloat controlWidth = trackControl.bounds.size.width;
    CGFloat strideCount = controlWidth / _document.pageCount;
    NSUInteger index = trackControl.value / strideCount;
    return index;
}

#pragma mark - MNKPDFPageTrackControl action methods

- (void)trackViewTouchDown:(MNKPDFPageTrackControl *)trackControl {
    
    NSUInteger index = [self trackControlPageIndex:trackControl];
    if (index != _document.lastOpenedPageIndex) {
        _pageNumberLabel.pageNumber = index + 1;
        [self updatePageThumbView:index];
        [self.delegate pageChosen:index];
    }
    trackControl.currentPageIndex = index;
}

- (void)trackViewValueChanged:(MNKPDFPageTrackControl *)trackControl {
    
    NSUInteger index = [self trackControlPageIndex:trackControl];
    if (index != trackControl.currentPageIndex) {
        _pageNumberLabel.pageNumber = index + 1;
        [self updatePageThumbView:index];
        trackControl.currentPageIndex = index;
    }
}

- (void)trackViewTouchUp:(MNKPDFPageTrackControl *)trackControl {
    
    NSUInteger index = [self trackControlPageIndex:trackControl];
    if (index != _document.lastOpenedPageIndex) {
        _pageNumberLabel.pageNumber = index + 1;
        [self updatePageThumbView:index];
        [self.delegate pageChosen:index];
    }
}

@end

