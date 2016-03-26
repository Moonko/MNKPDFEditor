//
//  MNKPDFThumbCell.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 06.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFThumbCell.h"
#import "MNKPDFThumbView.h"

#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180

@interface MNKPDFThumbCell ()

@property (nonatomic, strong) MNKPDFThumbView *thumbView;

@end

@implementation MNKPDFThumbCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        _thumbView = [[MNKPDFThumbView alloc] initWithFrame:self.bounds];
        [self addSubview:_thumbView];
    }
    return self;
}

- (void)prepareForReuse {
    
    [_thumbView removeFromSuperview];
    _thumbView = [[MNKPDFThumbView alloc] initWithFrame:self.bounds];
    [self addSubview:_thumbView];
}

- (void)renderThumbWithDocumentGUID:(NSString *)guid pageNumber:(NSUInteger)pageNumber
                               page:(CGPDFPageRef)pageRef thumbSize:(MNKPDFThumbSize)thumbSize {
    
    [_thumbView renderThumbWithFrame:self.bounds documentGUID:guid
                          pageNumber:pageNumber page:pageRef thumbSize:thumbSize];
}

- (void)setAngle:(NSUInteger)angle {
    
    if (angle != 0) {
        CGRect oldBounds = _thumbView.bounds;
        CGAffineTransform transform = CGAffineTransformRotate(_thumbView.transform, DEGREES_TO_RADIANS(angle));
        _thumbView.transform = transform;
        
        _thumbView.bounds = CGRectMake(0, 0, oldBounds.size.height, oldBounds.size.width);
    }
}

@end
