//
//  MNKPDFContentView.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 21.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFContentView.h"
#import "MNKPDFContentPage.h"
#import "MNKPDFDocument.h"
#import "MNKPDFDrawingView.h"
#import "MNKPDFThumbView.h"
#import "MNKPDFConstants.h"

static void *MNKPDFContentViewContext = &MNKPDFContentViewContext;

static inline CGFloat zoomScaleThatFits(CGSize target, CGSize source) {
    
    CGFloat widthScale = (target.width / source.width);
    CGFloat heightScale = (target.height / source.height);
    
    return widthScale < heightScale ? widthScale : heightScale;
}

@interface MNKPDFContentView () <UIScrollViewDelegate>

@property (nonatomic, strong) MNKPDFDocument *document;
@property (nonatomic, assign) NSUInteger pageNumber;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) MNKPDFContentPage *contentPage;
@property (nonatomic, strong) MNKPDFDrawingView *drawingView;
@property (nonatomic, assign) BOOL userDrawing;

@end

@implementation MNKPDFContentView

- (instancetype)initWithFrame:(CGRect)frame
                     document:(MNKPDFDocument *)document
                   pageNumber:(NSUInteger)number {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollsToTop = NO;
        self.delaysContentTouches = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                 UIViewAutoresizingFlexibleHeight);
        self.backgroundColor = [UIColor clearColor];
        self.autoresizesSubviews = NO;
        self.clipsToBounds = NO;
        self.delegate = self;
        
        _document = document;
        _pageNumber = number;
        
        CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)document.fileURL);
        CGPDFPageRef page = CGPDFDocumentGetPage(documentRef, number);
        
        NSUInteger pageIndex = [document.pages indexOfObject:@(number)];
        NSUInteger pageAngle = [document.angles[pageIndex] integerValue];

        _contentPage = [[MNKPDFContentPage alloc] initWithPage:page number:number angle:[document.angles[pageIndex] integerValue]];
        if (_contentPage) {
            
            _containerView = [[UIView alloc] initWithFrame:_contentPage.bounds];
            _containerView.autoresizesSubviews = NO;
            _containerView.userInteractionEnabled = YES;
            _containerView.contentMode = UIViewContentModeRedraw;
            _containerView.autoresizingMask = UIViewAutoresizingNone;
            _containerView.backgroundColor = [UIColor whiteColor];
            
            self.contentSize = _contentPage.bounds.size;
            [self centerScrollViewContent];
            
            MNKPDFThumbView *thumbView = [[MNKPDFThumbView alloc] initWithFrame:_contentPage.bounds angle:pageAngle];
            
            [thumbView renderThumbWithFrame:thumbView.bounds documentGUID:document.guid pageNumber:number page:page thumbSize:MNKPDFThumbSizeLarge];
            [_containerView addSubview:thumbView];
            
            [_containerView addSubview:_contentPage];
            
            _drawingView = [[MNKPDFDrawingView alloc] initWithFrame:_contentPage.bounds];
            _drawingView.userInteractionEnabled = NO;
            
            CGAffineTransform drawingViewTransform = CGAffineTransformRotate(_drawingView.transform, degreesToRadians(pageAngle));
            _drawingView.transform = drawingViewTransform;
            _drawingView.frame = CGRectMake(0.0f, 0.0f, _drawingView.bounds.size.width, _drawingView.bounds.size.height);
            NSData *imageData = [NSData dataWithContentsOfFile:[self imagePath]];
            _drawingView.image = [UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]];

            [_containerView addSubview:_drawingView];
            
            [self addSubview:_containerView];
            [self updateZoomProperties];
            self.zoomScale = self.minimumZoomScale;
            
            [self addObserver:self forKeyPath:@"frame" options:0 context:MNKPDFContentViewContext];
        }
        CGPDFDocumentRelease(documentRef);
    }
    
    return self;
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"frame" context:MNKPDFContentViewContext];
}

- (void)updateZoomProperties {
    
    CGFloat zoomScale = zoomScaleThatFits(self.bounds.size, _contentPage.bounds.size);
    self.minimumZoomScale = zoomScale;
    self.maximumZoomScale = zoomScale * MAXIMUM_SCALE;
}

- (void)centerScrollViewContent {
    
    CGFloat insetWidth = 0.0f;
    CGFloat insetHeight = 0.0f;
    
    CGSize boundsSize = self.bounds.size;
    CGSize contentSize = self.contentSize;
    
    if (contentSize.width < boundsSize.width) {
        insetWidth = (boundsSize.width - contentSize.width) * 0.5f;
    };
    if (contentSize.height < boundsSize.height) {
        insetHeight = (boundsSize.height - contentSize.height) * 0.5f;
    }
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(insetHeight, insetWidth, insetHeight, insetWidth);
    if (!UIEdgeInsetsEqualToEdgeInsets(self.contentInset, edgeInsets)) {
        self.contentInset = edgeInsets;
    }
}

- (void)resetZoomAnimated:(BOOL)animated {
    
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:animated];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (context == MNKPDFContentViewContext) {
        [self centerScrollViewContent];
        
        CGFloat oldMinimumZoomScale = self.minimumZoomScale;
        [self updateZoomProperties];
        if (self.zoomScale == oldMinimumZoomScale) {
            self.zoomScale = self.minimumZoomScale;
        } else {
            if (self.zoomScale < self.minimumZoomScale) {
                self.zoomScale = self.minimumZoomScale;
            } else if (self.zoomScale > self.maximumZoomScale) {
                self.zoomScale = self.maximumZoomScale;
            }
        }
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//   
//    if (!_userDrawing) {
//        [self.touchDelegate shouldHideToolbars];
//    }
//}

#pragma mark - UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self centerScrollViewContent];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    
    if (!_userDrawing) {
        [self.touchDelegate shouldHideToolbars];
    }
}

#pragma mark MNPDFDrawingView methods

- (void)setDrawingViewEnabled:(BOOL)enabled {
    
    _drawingView.userInteractionEnabled = enabled;
    _userDrawing = enabled;
    if (enabled) {
        for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *)gestureRecognizer;
                panGR.minimumNumberOfTouches = 2;
            }
        }
    } else {
        for (UIGestureRecognizer *gestureRecognizer in self.gestureRecognizers) {
            if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                UIPanGestureRecognizer *panGR = (UIPanGestureRecognizer *)gestureRecognizer;
                panGR.minimumNumberOfTouches = 1;
            }
        }
        [self saveImage];
    }
}

- (void)saveImage {
    
    [UIImagePNGRepresentation(_drawingView.image) writeToFile:[self imagePath] atomically:YES];
}

- (NSString *)imagePath {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    NSString *appendingString = [NSString stringWithFormat:@"%@/%i.png", _document.guid, (int)_pageNumber];
    return [documentsPath stringByAppendingPathComponent:appendingString];
}

- (void)undoLastDrawing {
    
    [_drawingView undo];
}

- (void)redoLastDrawing {
    
    [_drawingView redo];
}

- (void)clearDrawingView {
    
    [_drawingView clear];
}

@end
