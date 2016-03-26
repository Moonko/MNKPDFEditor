 //
//  MNKPDFModelViewController.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 23.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFModelViewController.h"
#import "MNKPDFDocument.h"
#import "MNKPDFContentViewController.h"
#import "MNKPDFContentView.h"

@interface MNKPDFModelViewController ()

@property (nonatomic, strong) MNKPDFDocument *document;
@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) NSUInteger nextIndex;

@end

@implementation MNKPDFModelViewController

- (instancetype)initWithDocument:(MNKPDFDocument *)document
              contentViewDelegate:(id<MNKPDFContentViewDelegate>)contentViewDelegate {
    
    self = [super init];
    if (self) {
        _document = document;
        _numberOfPages = _document.pageCount;
        self.contentViewDelegate = contentViewDelegate;
    }
    return self;
}

- (MNKPDFContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    NSUInteger pageNumber = [(NSNumber *)_document.pages[index] unsignedLongValue];
    NSLog(@"Page number: %lu", (unsigned long)pageNumber);
    MNKPDFContentViewController *contentViewController = [[MNKPDFContentViewController alloc]
                                                          initWithDocument:_document
                                                                pageNumber:pageNumber];
    contentViewController.contentView.touchDelegate = self.contentViewDelegate;
    return contentViewController;
}

- (NSUInteger)indexOfViewController:(MNKPDFContentViewController *)viewController {
    
    return [_document.pages indexOfObject:@(viewController.pageNumber)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(MNKPDFContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(MNKPDFContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == _numberOfPages) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    MNKPDFContentViewController *nextViewController =
                (MNKPDFContentViewController *)[pendingViewControllers firstObject];
    _nextIndex = [self indexOfViewController:nextViewController];
    [self.contentViewDelegate shouldHideToolbars];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        MNKPDFContentViewController *prevViewController = (MNKPDFContentViewController *)[previousViewControllers firstObject];
        [prevViewController resetContentViewZoom];
        _document.lastOpenedPageIndex = _nextIndex;
    }
}

@end
