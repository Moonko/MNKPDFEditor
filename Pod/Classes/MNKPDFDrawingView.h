//
//  MNKPDFDrawingView.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 27.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNKPDFDrawingTool;
@class MNKPDFDocument;

@interface MNKPDFDrawingView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) id<MNKPDFDrawingTool> currentTool;

- (void)undo;
- (BOOL)canUndo;

- (void)redo;
- (BOOL)canRedo;

- (void)clear;

@end
