//
//  MNKPDFModelViewController.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 23.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNKPDFDocument, MNKPDFContentViewController;

@protocol MNKPDFContentViewDelegate;

@interface MNKPDFModelViewController : UIViewController
<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, weak) id<MNKPDFContentViewDelegate> contentViewDelegate;

- (MNKPDFContentViewController *)viewControllerAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfViewController:(MNKPDFContentViewController *)viewController;

- (instancetype)initWithDocument:(MNKPDFDocument *)document contentViewDelegate:(id<MNKPDFContentViewDelegate>)contentViewDelegate;

@end
