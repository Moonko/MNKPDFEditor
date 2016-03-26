//
//  MNKPDFDrawingToolEraser.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 03/11/15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolEraser.h"

@implementation MNKPDFDrawingToolEraser

- (void)draw {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddPath(context, self.path);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
