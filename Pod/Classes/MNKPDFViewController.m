//
//  MNKPDFViewController.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 21.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFViewController.h"
#import "MNKPDFDocument.h"
#import "MNKPDFContentView.h"
#import "MNKPDFMainToolbar.h"
#import "MNKPDFMainPagebar.h"
#import "MNKPDFModelViewController.h"
#import "MNKPDFContentViewController.h"
#import "MNKPDFDrawingToolbar.h"
#import "MNKPDFDrawingToolbarButton.h"
#import "MNKPDFThumbsViewController.h"
#import "MNKPDFConstants.h"
#import "MNKPDFPaletteViewController.h"

@interface MNKPDFViewController ()
<MNKPDFMainToolbarDelegate, MNKPDFMainPagebarDelegate, UIGestureRecognizerDelegate,
MNKPDFContentViewDelegate, MNKPDFDrawingToolbarDelegate, MNKPDFThumbsViewControllerDelegate>

@property (nonatomic, strong) MNKPDFDocument *document;
@property (nonatomic, strong) MNKPDFModelViewController *modelViewController;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) MNKPDFMainToolbar *mainToolbar;
@property (nonatomic, strong) MNKPDFMainPagebar *mainPagebar;
@property (nonatomic, strong) MNKPDFDrawingToolbar *drawingToolbar;

@property (nonatomic, strong) UIPopoverController *popoverController;

@property (nonatomic, assign) BOOL userDrawing;
@property (nonatomic, assign) BOOL rotatingPage;

@end

@implementation MNKPDFViewController

- (instancetype)initWithDocument:(MNKPDFDocument *)document outputFilePath:(NSString *)outputFilePath {
    
    self = [super init];
    if (self) {
        if (document) {
            _document = document;
            _modelViewController = [[MNKPDFModelViewController alloc]
                                    initWithDocument:document contentViewDelegate:self];
            _userDrawing = NO;
            _rotatingPage = NO;
            _outputFilePath = outputFilePath;
        } else {
            return nil;
        }
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @20.0f};
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:options];
    NSUInteger index = _document.lastOpenedPageIndex;
    MNKPDFContentViewController *startingViewController = [_modelViewController
                                                           viewControllerAtIndex:index];
    NSArray *viewControllers = @[startingViewController];
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    _pageViewController.dataSource = _modelViewController;
    _pageViewController.delegate = _modelViewController;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    _pageViewController.view.frame = self.view.bounds;
    [_pageViewController didMoveToParentViewController:self];
    
    CGRect mainToolbarRect = self.view.bounds;
    mainToolbarRect.size.height = MAIN_TOOLBAR_HEIGHT;
    _mainToolbar = [[MNKPDFMainToolbar alloc] initWithFrame:mainToolbarRect];
    _mainToolbar.delegate = self;
    _mainToolbar.hidden = YES;
    [self.view addSubview:_mainToolbar];
    
    CGRect pagebarRect = self.view.bounds;
    pagebarRect.size.height = PAGEBAR_HEIGHT;
    pagebarRect.origin.y = self.view.bounds.size.height - pagebarRect.size.height;
    _mainPagebar = [[MNKPDFMainPagebar alloc] initWithFrame:pagebarRect document:_document];
    _mainPagebar.delegate = self;
    _mainPagebar.hidden = YES;
    [self.view addSubview:_mainPagebar];

    CGRect drawingToolbarRect = CGRectMake(DEFAULT_SPACING, _mainToolbar.frame.origin.x + _mainToolbar.frame.size.height + DEFAULT_SPACING, DRAWING_TOOLBAR_WIDTH, DRAWING_TOOLBAR_HEIGHT);
    _drawingToolbar = [[MNKPDFDrawingToolbar alloc] initWithFrame:drawingToolbarRect];
    _drawingToolbar.delegate = self;
    _drawingToolbar.hidden = YES;
    [self.view addSubview:_drawingToolbar];

    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(handleSingleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleTapRecognizer];
}

- (void)hideToolbars {
    
    [_mainToolbar hide];
    [_mainPagebar hide];
    [_drawingToolbar hide];
}

- (void)showToolbars {
    
    [_mainToolbar show];
    [_mainPagebar show];
    [_drawingToolbar show];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (!_userDrawing) {
        if (_mainToolbar.hidden) {
            [self showToolbars];
        } else {
            [self hideToolbars];
        }
    }
}

- (void)closeDocument {
    
    [self saveChangesToFileIfNeeded];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)saveChangesToFileIfNeeded {
    
    if (![self hasChanges]) {
        NSLog(@"No changes in %@ – No saving then", _document.fileName);
        [_document save];
        [self.delegate dismissPDFViewController:self];
        return;
    }
    
    UIView *waitingView = [[UIView alloc] initWithFrame:self.view.window.bounds];
    waitingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
    waitingView.userInteractionEnabled = YES;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = waitingView.center;
    
    [waitingView addSubview:activityIndicator];
    [self.view.window addSubview:waitingView];
    [activityIndicator startAnimating];
    [self.view.window bringSubviewToFront:waitingView];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        CGPDFDocumentRef document = CGPDFDocumentCreateWithURL((__bridge CFURLRef)_document.fileURL);
        NSMutableData *pdfData = [NSMutableData data];
        UIGraphicsBeginPDFContextToData(pdfData, self.view.bounds, nil);
        for (int i = 0; i < _document.pages.count; ++i) {
            NSUInteger pageNumber = [_document.pages[i] integerValue];
            CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, pageNumber);
            
            CGRect cropBoxRect = CGPDFPageGetBoxRect(pageRef, kCGPDFCropBox);
            CGRect mediaBoxRect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
            CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
            
            NSUInteger rotationAngle = [_document.angles[i] integerValue];
            int pageAngle = (CGPDFPageGetRotationAngle(pageRef) + rotationAngle) % 360;
            
            NSInteger pageWidth = 0;
            NSInteger pageHeight = 0;
            
            switch (pageAngle) // Page rotation angle (in degrees)
            {
                default: // Default case
                case 0: case 180: // 0 and 180 degrees
                {
                    pageWidth = effectiveRect.size.width;
                    pageHeight = effectiveRect.size.height;
                    break;
                }
                    
                case 90: case 270: // 90 and 270 degrees
                {
                    pageWidth = effectiveRect.size.height;
                    pageHeight = effectiveRect.size.width;
                    break;
                }
            }
            
            if (pageWidth % 2) pageWidth--;
            if (pageHeight % 2) pageHeight--;
            
            CGRect pageFrame = CGRectZero;
            pageFrame.size = CGSizeMake(pageWidth, pageHeight);
            
            UIGraphicsBeginPDFPageWithInfo(pageFrame, nil);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            CGContextScaleCTM(context, 1.0f, -1.0f);
            CGContextTranslateCTM(context, 0.0f, -pageFrame.size.height);
            CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(pageRef, kCGPDFCropBox, pageFrame, (int)rotationAngle, true));
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
            CGContextDrawPDFPage(context, pageRef);
            CGContextRestoreGState(context);
            CGContextTranslateCTM(context, pageWidth / 2, pageHeight / 2);
            CGContextRotateCTM(context, degreesToRadians(rotationAngle));
            CGFloat aspectRatio = (CGFloat)pageWidth / pageHeight;
            if (rotationAngle == 90 || rotationAngle == 270) {
                CGContextTranslateCTM(context, - pageHeight / 2, - pageWidth / 2);
                CGContextScaleCTM(context, 1 / aspectRatio, aspectRatio);
            } else {
                CGContextTranslateCTM(context, - pageWidth / 2, - pageHeight / 2);
            }
            UIImage *drawnImage = [UIImage imageWithContentsOfFile:[_document imagePathForPage:pageNumber]];
            [drawnImage drawInRect:pageFrame];
        }
        UIGraphicsEndPDFContext();
        CGPDFDocumentRelease(document);
        
        NSString *filePath = self.outputFilePath ? self.outputFilePath : _document.filePath;
        
        if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:pdfData attributes:nil]) {
            NSLog(@"Document %@ was successfully saved", _document.fileName);
        } else {
            NSLog(@"Document %@ was not saved. Something went wrong", _document.fileName);
        }
        [_document remove];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [waitingView removeFromSuperview];
            [self.delegate dismissPDFViewController:self];
        });
    });
}

- (BOOL)hasChanges {
    
    NSArray *drawnImages = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[_document pdfDirectory] error:nil];
    if (drawnImages.count > 0) {
        return YES;
    }
    for (int i = 0; i < _document.pageCount; ++i) {
        if ([_document.pages[i] integerValue] != (i+1) ||
            [_document.angles[i] integerValue] != 0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    return !_userDrawing;
}

#pragma mark – MNKPDFContentViewDelegate methods

- (void)shouldHideToolbars {
    
    [self hideToolbars];
}

#pragma mark - MNKPDFMainToolbarDelegate methods

- (void)mainToolbarButtonTappedWithType:(MKPDFMainToolbarButtonType)buttonType {
    
    switch (buttonType) {
        case MNKPDFMainToolbarButtonTypeDone: {
            [self closeDocument];
            break;
        }
        case MNKPDFMainToolbarButtonTypeThumbs: {
            MNKPDFThumbsViewController *thumbsViewController = [[MNKPDFThumbsViewController alloc] initWithDocument:_document];
            thumbsViewController.delegate = self;
            [self presentViewController:thumbsViewController animated:YES completion:nil];
            break;
        }
        case MNKPDFMainToolbarButtonTypeBookmark: {
            // MAKE BOOKMARK
            break;
        }
    }
}

#pragma mark – MNKPDFMainPagebar delegate methods

- (void)pageChosen:(NSUInteger)index {
    
    MNKPDFContentViewController *chosenViewController = [_modelViewController viewControllerAtIndex:index];
    NSArray *viewControllers = @[chosenViewController];
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    _document.lastOpenedPageIndex = index;
    [_mainPagebar update];
}

- (void)rotatePage {
    
    if (!_rotatingPage) {
        _rotatingPage = YES;
        MNKPDFContentViewController *contentViewController = (MNKPDFContentViewController *)[_pageViewController.viewControllers firstObject];
        NSUInteger pageIndex = [_document.pages indexOfObject:@(contentViewController.pageNumber)];
        NSUInteger pageAngle = [_document.angles[pageIndex] integerValue];
        pageAngle = (pageAngle + 90) % 360;
        _document.angles[pageIndex] = @(pageAngle);
        
        UIView *contentView = contentViewController.contentView;
        CGRect contentFrame = contentView.frame;
        CGFloat xOffset = self.view.frame.origin.x - contentFrame.origin.x;
        CGFloat yOffset = self.view.frame.origin.y - contentFrame.origin.y;
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGAffineTransform transform = CGAffineTransformRotate(contentView.transform, M_PI_2);
            contentView.transform = transform;
            
            contentView.frame = CGRectMake(xOffset, yOffset, self.view.bounds.size.width, self.view.bounds.size.height);
        }completion: ^(BOOL finished) {
            _rotatingPage = NO;
        }];
    }
    
}

#pragma mark – MNKPDFDrawingToolbar delegate methods

- (void)drawingToolbarButtonTapped:(MNKPDFDrawingToolbarButton *)button {
    
    MNKPDFContentViewController *currentViewController =
    (MNKPDFContentViewController *)[[_pageViewController viewControllers] firstObject];
    
    if (button.toolType != MNKPDFDrawingToolbarButtonTypeUndo &&
        button.toolType != MNKPDFDrawingToolbarButtonTypeRedo &&
        button.toolType != MNKPDFDrawingToolbarButtonTypeClear &&
        button.toolType != MNKPDFDrawingToolbarButtonTypePalette) {
        if (button.selected) {
            [_mainPagebar hide];
            [_mainToolbar hide];
        } else {
            [_mainPagebar show];
            [_mainToolbar show];
        }
        
        _pageViewController.dataSource = button.selected ? nil : _modelViewController;
        
        [currentViewController enableDrawing:button.selected];
        _userDrawing = button.selected;
    }
    
    if (button.toolType != MNKPDFDrawingToolbarButtonTypePalette) {
        [currentViewController handleTappedDrawingToolbarButton:button];
    } else {
        MNKPDFPaletteViewController *paletteViewController = [[MNKPDFPaletteViewController alloc] init];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            paletteViewController.mode = MNKPDFPaletteViewControllerModePopover;
            CGSize popoverSize = CGSizeMake(PALETTE_WIDTH, PALETTE_HEIGHT);
            paletteViewController.view.frame = CGRectMake(0.0f, 0.0f, PALETTE_WIDTH, PALETTE_HEIGHT);
            _popoverController = [[UIPopoverController alloc] initWithContentViewController:paletteViewController];
            _popoverController.popoverContentSize = popoverSize;
            CGRect presentedFrame = [self.view convertRect:button.frame fromView:_drawingToolbar];
            [_popoverController presentPopoverFromRect:presentedFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:true];
        } else {
            paletteViewController.mode = MNKPDFPaletteViewControllerModeModal;
            [self presentViewController:paletteViewController animated:true completion:nil];
        }
    }
}

#pragma mark – MNKPDFThumbsViewControllerDelegate

- (void)dismissThumbsViewController:(MNKPDFThumbsViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self pageChosen:_document.lastOpenedPageIndex];
}

- (void)thumbsViewController:(MNKPDFThumbsViewController *)viewController pageTapped:(NSUInteger)page {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self pageChosen:page];
}

@end