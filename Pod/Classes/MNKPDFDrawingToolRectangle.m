
//
//  MNKPDFDrawingToolRectangle.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 02/11/15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolRectangle.h"

@interface MNKPDFDrawingToolRectangle ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation MNKPDFDrawingToolRectangle

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
    CGRect rectToDraw = CGRectMake(_startPoint.x, _startPoint.y, _endPoint.x - _startPoint.x, _endPoint.y - _startPoint.y);
    if (self.isFilled) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillRect(context, rectToDraw);
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeRect(context, rectToDraw);
    }
}

@end
