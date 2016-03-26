//
//  MNKPDFDrawingToolPen.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 27.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolPen.h"

@interface MNKPDFDrawingToolPen ()

@property (nonatomic, assign) CGMutablePathRef path;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) CGPoint previousPoint1;
@property (nonatomic, assign) CGPoint previousPoint2;

@end

static inline CGPoint getMidPoint(CGPoint p1, CGPoint p2) {
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@implementation MNKPDFDrawingToolPen

@synthesize lineColor;
@synthesize lineAlpha;
@synthesize lineWidth;

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _path = CGPathCreateMutable();
    }
    return self;
}

- (void)setInitialPoint:(CGPoint)initialPoint {
    
    _currentPoint = initialPoint;
    _previousPoint1 = initialPoint;
}

- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint {
    _previousPoint2 = _previousPoint1;
    _previousPoint1 = _currentPoint;
    _currentPoint = endPoint;
    
    CGPoint mid1 = getMidPoint(_previousPoint1, _previousPoint2);
    CGPoint mid2 = getMidPoint(_currentPoint, _previousPoint1);
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, _previousPoint1.x, _previousPoint1.y, mid2.x, mid2.y);
    
    CGRect boxNeedsToDisplay = CGPathGetBoundingBox(subpath);
    boxNeedsToDisplay = CGRectInset(boxNeedsToDisplay, -self.lineWidth / 2, -self.lineWidth / 2);

    _boxNeedsToDisplay = boxNeedsToDisplay;
    
    CGPathAddPath(_path, NULL, subpath);
    CGPathRelease(subpath);
}

- (void)draw {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, _path);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextSetAlpha(context, self.lineAlpha);
    CGContextStrokePath(context);
}

- (void)dealloc {
    
    CGPathRelease(_path);
}

@end
