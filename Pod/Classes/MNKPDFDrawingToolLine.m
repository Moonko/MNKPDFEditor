//
//  MNKPDFDrawingToolLine.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 03/11/15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolLine.h"

@interface MNKPDFDrawingToolLine ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation MNKPDFDrawingToolLine

@synthesize lineColor;
@synthesize lineWidth;
@synthesize lineAlpha;

- (void)setInitialPoint:(CGPoint)initialPoint {
    
    _startPoint = initialPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint {
    
    _endPoint = endPoint;
}

- (void)draw {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);
    CGContextStrokePath(context);
}

@end
