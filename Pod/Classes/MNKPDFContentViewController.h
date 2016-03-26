//
//  MNKPDFContentViewController.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 23.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFEnumList.h"

@class MNKPDFContentView, MNKPDFDocument, MNKPDFDrawingToolbarButton;

@interface MNKPDFContentViewController : UIViewController

@property (nonatomic, strong, readonly) MNKPDFContentView *contentView;
@property NSUInteger pageNumber;

- (id)initWithDocument:(MNKPDFDocument *)document pageNumber:(NSUInteger)pageNumber;

- (void)resetContentViewZoom;

- (void)enableDrawing:(BOOL)enable;
- (void)handleTappedDrawingToolbarButton:(MNKPDFDrawingToolbarButton *)button;

@end
