//
//  MNKPDFThumbView.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 06.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFThumbView.h"
#import "MNKPDFThumbOperation.h"

@interface MNKPDFThumbView ()

@property (nonatomic, strong) MNKPDFThumbOperation *thumbOperation;
@property (nonatomic, assign) NSUInteger pageAngle;

@end

@implementation MNKPDFThumbView

- (NSOperationQueue *)thumbQueue {
    
    static dispatch_once_t token;
    static NSOperationQueue *queue;
    dispatch_once(&token, ^{
        queue = [[NSOperationQueue alloc] init];
    });
    return queue;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pageAngle = 0;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame angle:(NSUInteger)angle {
    
    self = [self initWithFrame:frame];
    if (self) {
        _pageAngle = angle;
        CGRect oldBounds = self.bounds;
        CGAffineTransform transform = CGAffineTransformRotate(self.transform, degreesToRadians(_pageAngle));
        self.transform = transform;
        
        self.frame = CGRectMake(0, 0, oldBounds.size.width, oldBounds.size.height);

    }
    return self;
}

- (void)renderThumbWithFrame:(CGRect)frame documentGUID:(NSString *)guid pageNumber:(NSUInteger)pageNumber page:(CGPDFPageRef)pageRef thumbSize:(MNKPDFThumbSize)thumbSize {
    
    _thumbOperation = [[MNKPDFThumbOperation alloc] initWithGUID:guid pageNumber:pageNumber page:pageRef size:thumbSize thumbView:self];
    [[self thumbQueue] addOperation:_thumbOperation];
}

- (void)dealloc {
    
    [_thumbOperation cancel];
}

@end
