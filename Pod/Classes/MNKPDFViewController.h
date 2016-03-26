//
//  MNKPDFViewController.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 21.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNKPDFDocument, MNKPDFViewController, MNKPDFMainToolbar;
@class MNKPDFDrawingToolbarButton;

@protocol MNKPDFViewControllerDelegate <NSObject>

@optional

- (void)dismissPDFViewController:(MNKPDFViewController *)viewController;

@end

@interface MNKPDFViewController : UIViewController

@property (nonatomic, weak) id<MNKPDFViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *outputFilePath;

- (instancetype)initWithDocument:(MNKPDFDocument *)document outputFilePath:(NSString *)outputFilePath;

@end
