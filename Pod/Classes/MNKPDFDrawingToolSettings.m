//
//  MNKPDFDrawingToolSettings.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 03/11/15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolSettings.h"
#import "MNKPDFConstants.h"

@implementation MNKPDFDrawingToolSettings

+ (instancetype)sharedSettings {
    
    static dispatch_once_t token;
    static MNKPDFDrawingToolSettings *instance;
    dispatch_once(&token, ^{
        instance = [[MNKPDFDrawingToolSettings alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.lineColor = LINE_COLOR;
        self.lineWidth = LINE_WIDTH;
        self.lineAlpha = LINE_ALPHA;
    }
    return self;
}

- (id<MNKPDFDrawingTool>)drawingToolWithCurrentSettings {
    
    id<MNKPDFDrawingTool> currentTool;
    switch (self.toolType) {
        case MNKPDFDrawingToolTypePen: {
            currentTool = [[MNKPDFDrawingToolPen alloc] init];
            break;
        }
        case MNKPDFDrawingToolTypeEraser: {
            currentTool = [[MNKPDFDrawingToolEraser alloc] init];
            break;
        }
        case MNKPDFDrawingToolTypeLine: {
            currentTool = [[MNKPDFDrawingToolLine alloc] init];
            break;
        }
        case MNKPDFDrawingToolTypeEllipseFilled: {
            currentTool = [[MNKPDFDrawingToolEllipse alloc] init];
            MNKPDFDrawingToolEllipse *ellipse = currentTool;
            ellipse.filled = YES;
            break;
        }
        case MNKPDFDrawingToolTypeEllipseStroked: {
            currentTool = [[MNKPDFDrawingToolEllipse alloc] init];
            MNKPDFDrawingToolEllipse *ellipse = currentTool;
            ellipse.filled = NO;
            break;
        }
        case MNKPDFDrawingToolTypeRectangleFilled: {
            currentTool = [[MNKPDFDrawingToolRectangle alloc] init];
            MNKPDFDrawingToolRectangle *rectangle = currentTool;
            rectangle.filled = YES;
            break;
        }
        case MNKPDFDrawingToolTypeRectangleStroked: {
            currentTool = [[MNKPDFDrawingToolRectangle alloc] init];
            MNKPDFDrawingToolRectangle *rectangle = currentTool;
            rectangle.filled = NO;
            break;
        }
    }
    currentTool.lineColor = self.lineColor;
    currentTool.lineWidth = self.lineWidth;
    currentTool.lineAlpha = self.lineAlpha;
    
    return currentTool;
}

@end
