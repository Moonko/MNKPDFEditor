
//
//  MNKPDFThumbOperation.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 06.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFThumbOperation.h"
#import "MNKPDFThumbView.h"
#import "MNKPDFEnumList.h"

static inline NSString *cachesPath() {
    
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

@interface MNKPDFThumbOperation ()

@property (nonatomic, assign) CGPDFPageRef page;
@property (nonatomic, strong) NSString *guid;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, weak) MNKPDFThumbView *requestedView;
@property (nonatomic, assign) NSUInteger pageNumber;

@end

@implementation MNKPDFThumbOperation

+ (NSObject *)sharedToken {
    
    static dispatch_once_t predicate;
    static NSObject *token;
    dispatch_once(&predicate, ^{
        token = [[NSObject alloc] init];
    });
    return token;
}

- (NSString *)cachePathForDocument {
    
    NSString *path = [cachesPath() stringByAppendingPathComponent:_guid];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return [cachesPath() stringByAppendingPathComponent:_guid];
}

- (NSString *)pathForThumbImage {
    
    NSString *pathComponent = [NSString stringWithFormat:@"%lu%f%f.png", (unsigned long)_pageNumber, _size.width, _size.height];
    return [[self cachePathForDocument] stringByAppendingPathComponent:pathComponent];
}

- (CGSize)thumbSize:(MNKPDFThumbSize)size {
    
    CGSize result;
    switch (size) {
        case MNKPDFThumbSizeSmall: {
            result = CGSizeMake(22.0f, 28.0f);
            break;
        }
        case MNKPDFThumbSizeMedium: {
            result = CGSizeMake(240.0f, 240.0f);
            break;
        }
        case MNKPDFThumbSizeLarge: {
            result = CGSizeMake(240.0f, 320.0f);
            break;
        }
    }
    CGFloat scale = [[UIScreen mainScreen] scale];
    result.width *= scale;
    result.height *= scale;
    return result;
}

- (instancetype)initWithGUID:(NSString *)guid pageNumber:(NSUInteger)pageNumber page:(CGPDFPageRef)pageRef size:(MNKPDFThumbSize)size thumbView:(MNKPDFThumbView *)thumbView {
    
    self = [super init];
    if (self) {
        _page = pageRef;
        _size = [self thumbSize:size];
        _requestedView = thumbView;
        _guid = guid;
        _pageNumber = pageNumber;
    }
    return self;
}

- (void)start {
    
    UIImage *result = nil;
    @synchronized([MNKPDFThumbOperation sharedToken]) {
        result = [[UIImage alloc] initWithContentsOfFile:[self pathForThumbImage]];
        if (result && !self.cancelled) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_requestedView) {
                    _requestedView.image = result;
                }
            });
            return;
        }
    }
    
    if (_page != NULL && !self.cancelled) {
        
        CGPDFPageRetain(_page);
        CGImageRef thumbImage = NULL;
        CGFloat thumbWidth = _size.width;
        CGFloat thumbHeight = _size.height;
        
        CGRect cropBoxRect = CGPDFPageGetBoxRect(_page, kCGPDFCropBox);
        CGRect mediaBoxRect = CGPDFPageGetBoxRect(_page, kCGPDFMediaBox);
        CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
        
        NSInteger pageAngle = CGPDFPageGetRotationAngle(_page);
        
        CGFloat pageWidth = 0.0f;
        CGFloat pageHeight = 0.0f;
        
        switch (pageAngle) {
            default:
            case 0: case 180: {
                pageWidth = effectiveRect.size.width;
                pageHeight = effectiveRect.size.height;
                break;
            }
            case 90: case 270: {
                pageHeight = effectiveRect.size.width;
                pageWidth = effectiveRect.size.height;
                break;
            }
        }
        
        CGFloat scale = MIN(thumbWidth / pageWidth, thumbHeight / pageHeight);
        NSInteger imageWidth = pageWidth * scale;
        NSInteger imageHeight = pageHeight * scale;
        
        if (imageWidth % 2) imageWidth--;
        if (imageHeight % 2) imageHeight--;
        
        CGColorSpaceRef rgbColorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = (kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
        CGContextRef context = CGBitmapContextCreate(NULL, imageWidth, imageHeight,
                                                     8, 0, rgbColorSpaceRef, bitmapInfo);
        if (context != NULL && !self.cancelled) {
            CGRect imageRect = CGRectMake(0.0f, 0.0f, imageWidth, imageHeight);
            CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
            CGContextFillRect(context, imageRect);
            CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_page, kCGPDFCropBox,
                                                                     imageRect, 0, true));
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            CGContextSetRenderingIntent(context, kCGRenderingIntentDefault);
            CGContextDrawPDFPage(context, _page);
            thumbImage = CGBitmapContextCreateImage(context);
        }
        result = [[UIImage alloc] initWithCGImage:thumbImage];
        if (!self.cancelled) {
            if (result) {
                @synchronized([MNKPDFThumbOperation sharedToken]) {
                    [UIImagePNGRepresentation(result) writeToFile:[self pathForThumbImage] atomically:YES];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        if (_requestedView) {
                            _requestedView.image = result;
                        }
                    });
                }
            }
        }
        CGContextRelease(context);
        CGColorSpaceRelease(rgbColorSpaceRef);
        CGPDFPageRelease(_page);
        CGImageRelease(thumbImage);
    }
}

@end
