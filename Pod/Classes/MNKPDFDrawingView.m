//
//  MNKPDFDrawingView.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 27.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingView.h"
#import "MNKPDFDrawingTools.h"
#import "MNKPDFDocument.h"
#import "MNKPDFDrawingToolSettings.h"

@interface MNKPDFDrawingView ()
<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint previousTouchPoint;

@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;

@end

@implementation MNKPDFDrawingView

- (id)initWithFrame:(CGRect)frame  {
    
    self = [super initWithFrame:frame];
    if (self) {
        _pathArray = [NSMutableArray array];
        _bufferArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = YES;
        self.multipleTouchEnabled = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    _currentTool = [[MNKPDFDrawingToolSettings sharedSettings] drawingToolWithCurrentSettings];
    
    _previousTouchPoint = touchPoint;
    
    [_pathArray addObject:_currentTool];
    [_currentTool setInitialPoint:touchPoint];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    _previousTouchPoint = touchPoint;
    [_currentTool moveFromPoint:_previousTouchPoint toPoint:touchPoint];
    
    if ([_currentTool isKindOfClass:[MNKPDFDrawingToolPen class]]) {
        MNKPDFDrawingToolPen *penTool = (MNKPDFDrawingToolPen *)_currentTool;
        CGRect boxNeedsToDisplay = penTool.boxNeedsToDisplay;
        [self setNeedsDisplayInRect:boxNeedsToDisplay];
    } else {
        [self setNeedsDisplay];
    }

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self touchesMoved:touches withEvent:event];
    [self finishDrawing];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (void)drawRect:(CGRect)rect {
    
    [_image drawInRect:self.bounds];
    [self.currentTool draw];
}

- (void)updateImageWithRedrawing:(BOOL)redraw {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    if (redraw) {
        for (id<MNKPDFDrawingTool>tool in _pathArray) {
            [tool draw];
        }
    } else {
        [_image drawAtPoint:CGPointZero];
        [_currentTool draw];
    }
    _image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)finishDrawing {
    
    [self updateImageWithRedrawing:NO];
    [_bufferArray removeAllObjects];
    _currentTool = nil;
}

- (void)undo {
    
    if ([self canUndo]) {
        _currentTool = nil;
        id <MNKPDFDrawingTool>tool = [_pathArray lastObject];
        [_bufferArray addObject:tool];
        [_pathArray removeLastObject];
        [self updateImageWithRedrawing:YES];
        [self setNeedsDisplay];
    }
}

- (void)redo {
    
    if ([self canRedo]) {
        _currentTool = nil;
        id<MNKPDFDrawingTool>tool = [_bufferArray lastObject];
        [_pathArray addObject:tool];
        [_bufferArray removeLastObject];
        [self updateImageWithRedrawing:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)canUndo {
    
    return _pathArray.count > 0;
}

- (BOOL)canRedo {
    
    return _bufferArray.count > 0;
}

- (void)clear {
    
    _currentTool = nil;
    [_bufferArray removeAllObjects];
    [_pathArray removeAllObjects];
    _image = nil;
    [self setNeedsDisplay];
}

@end
