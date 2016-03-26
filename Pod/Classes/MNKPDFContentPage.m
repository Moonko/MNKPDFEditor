//
//  MNKPDFContentPage.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 21.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFContentPage.h"
#import "MNKPDFTiledLayer.h"

@interface MNKPDFContentPage ()

@property (nonatomic, assign) CGPDFPageRef pageRef;
@property (nonatomic, assign) NSUInteger pageAngle;
@property (nonatomic, assign) NSUInteger pageNumber;

@property (nonatomic, assign) CGFloat pageWidth;
@property (nonatomic, assign) CGFloat pageHeight;
@property (nonatomic, assign) CGFloat pageOffsetX;
@property (nonatomic, assign) CGFloat pageOffsetY;

@end

@implementation MNKPDFContentPage

+ (Class)layerClass {
    
    return [MNKPDFTiledLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        self.userInteractionEnabled = NO;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return  self;
}

- (instancetype)initWithPage:(CGPDFPageRef)page number:(NSUInteger)number angle:(NSUInteger)angle {
    
    CGRect viewRect = CGRectZero;
    if (page != NULL) {
        _pageRef = page;
        CGPDFPageRetain(_pageRef);
        _pageNumber = number;
        
        CGRect cropBoxRect = CGPDFPageGetBoxRect(_pageRef, kCGPDFCropBox);
        CGRect mediaBoxRect = CGPDFPageGetBoxRect(_pageRef, kCGPDFMediaBox);
        CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
        
        _pageAngle = angle;
        NSUInteger pageAngle = (CGPDFPageGetRotationAngle(page) + _pageAngle) % 360;
        switch (pageAngle) {
            case 0: case 180: {
                _pageWidth = effectiveRect.size.width;
                _pageHeight = effectiveRect.size.height;
                _pageOffsetX = effectiveRect.origin.x;
                _pageOffsetY = effectiveRect.origin.y;
                break;
            }
            case 90: case 270: {
                _pageWidth = effectiveRect.size.height;
                _pageHeight = effectiveRect.size.width;
                _pageOffsetX = effectiveRect.origin.y;
                _pageOffsetY = effectiveRect.origin.x;
                break;
            }
            default:
                break;
        }
        
        int page_w = _pageWidth;
        int page_h = _pageHeight;
        
        if (page_w % 2) page_w--;
        if (page_h % 2) page_h--;
        
        viewRect.size = CGSizeMake(page_w, page_h);
    } else {
        NSAssert(NO, @"CGPDFPageRef == NULL");
    }
    return [self initWithFrame:viewRect];
}

- (void)dealloc {
    
    CGPDFPageRelease(_pageRef);
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextFillRect(context, CGContextGetClipBoundingBox(context));
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_pageRef, kCGPDFCropBox, self.bounds, (int)_pageAngle, true));
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
    CGContextDrawPDFPage(context, _pageRef);
}

@end
