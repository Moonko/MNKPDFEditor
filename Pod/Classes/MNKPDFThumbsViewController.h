//
//  MNKPDFThumbsViewController.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 04.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNKPDFDocument, MNKPDFThumbsViewController;

@protocol MNKPDFThumbsViewControllerDelegate <NSObject>

- (void)thumbsViewController:(MNKPDFThumbsViewController *)viewController pageTapped:(NSUInteger)page;

- (void)dismissThumbsViewController:(MNKPDFThumbsViewController *)viewController;

@end

@interface MNKPDFThumbsViewController : UIViewController

@property (nonatomic, weak) id<MNKPDFThumbsViewControllerDelegate> delegate;

- (instancetype)initWithDocument:(MNKPDFDocument *)document;

@end
