//
//  MNKPDFContentView.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 21.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFEnumList.h"

@protocol MNKPDFDrawingTool;
@class MNKPDFDocument;

@protocol MNKPDFContentViewDelegate <NSObject>

@required

- (void)shouldHideToolbars;

@end

@interface MNKPDFContentView : UIScrollView

@property (nonatomic, weak) id<MNKPDFContentViewDelegate> touchDelegate;

- (instancetype)initWithFrame:(CGRect)frame document:(MNKPDFDocument *)document pageNumber:(NSUInteger)number;

- (void)resetZoomAnimated:(BOOL)animated;

- (void)setDrawingViewEnabled:(BOOL)enabled;
- (void)undoLastDrawing;
- (void)redoLastDrawing;
- (void)clearDrawingView;

@end
