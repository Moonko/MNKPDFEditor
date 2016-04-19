
//
//  MNKPDFDrawingToolCircle.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 02/11/15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolEllipse.h"

@interface MNKPDFDrawingToolEllipse ()

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation MNKPDFDrawingToolEllipse

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
    CGRect rectToDraw = CGRectMake(self.startPoint.x, self.startPoint.y, self.endPoint.x - self.startPoint.x, self.endPoint.y - self.startPoint.y);
    if (self.filled) {
        CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
        CGContextFillEllipseInRect(context, rectToDraw);
    } else {
        CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextStrokeEllipseInRect(context, rectToDraw);
    }
}

@end
