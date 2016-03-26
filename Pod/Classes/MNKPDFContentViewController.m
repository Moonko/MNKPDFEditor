//
//  MNKPDFContentViewController.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 23.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFContentViewController.h"
#import "MNKPDFContentView.h"
#import "MNKPDFDocument.h"
#import "MNKPDFDrawingToolbarButton.h"
#import "MNKPDFDrawingTools.h"
#import "MNKPDFDrawingToolSettings.h"

@implementation MNKPDFContentViewController

- (instancetype)initWithDocument:(MNKPDFDocument *)document pageNumber:(NSUInteger)pageNumber {
    
    self = [super init];
    if (self) {
        _contentView = [[MNKPDFContentView alloc] initWithFrame:self.view.frame
                                                       document:document
                                                     pageNumber:pageNumber];
        self.pageNumber = pageNumber;
        [self.view addSubview:_contentView];
        
    }
    return self;
}

- (void)resetContentViewZoom {
    
    [_contentView resetZoomAnimated:NO];
}

- (void)enableDrawing:(BOOL)enable {
    
    [_contentView setDrawingViewEnabled:enable];
}

- (void)handleTappedDrawingToolbarButton:(MNKPDFDrawingToolbarButton *)button {
    
    switch (button.toolType) {
        case MNKPDFDrawingToolbarButtonTypePen: {
            [MNKPDFDrawingToolSettings sharedSettings].toolType = MNKPDFDrawingToolTypePen;
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeLine: {
            [MNKPDFDrawingToolSettings sharedSettings].toolType = MNKPDFDrawingToolTypeLine;
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeEllipseFilled: {
            [MNKPDFDrawingToolSettings sharedSettings].toolType = MNKPDFDrawingToolTypeEllipseFilled;
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeEllipseStroked: {
            [MNKPDFDrawingToolSettings sharedSettings].toolType = MNKPDFDrawingToolTypeEllipseStroked;
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeRectangleFilled: {
            [MNKPDFDrawingToolSettings sharedSettings].toolType = MNKPDFDrawingToolTypeRectangleFilled;
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeRectangleStroked: {
            [MNKPDFDrawingToolSettings sharedSettings].toolType = MNKPDFDrawingToolTypeRectangleStroked;
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeEraser: {
            [MNKPDFDrawingToolSettings sharedSettings].toolType = MNKPDFDrawingToolTypeEraser;
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeUndo: {
            [_contentView undoLastDrawing];
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeRedo: {
            [_contentView redoLastDrawing];
            break;
        }
        case MNKPDFDrawingToolbarButtonTypeClear: {
            [_contentView clearDrawingView];
            break;
        }
        default:
            break;
    }
}

@end
