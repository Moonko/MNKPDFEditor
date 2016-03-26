//
//  MNKPDFPageTrackControl.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 25.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFPageTrackControl.h"

@implementation MNKPDFPageTrackControl

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = NO;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.backgroundColor = [UIColor clearColor];
        self.exclusiveTouch = YES;
    }
    return self;
}

- (CGFloat)limitValue:(CGFloat)valueX {
    
    CGFloat minX = self.bounds.origin.x;
    CGFloat maxX = (self.bounds.size.width -1.0f);
    
    if (valueX < minX) {
        valueX = minX;
    }
    if (valueX > maxX) {
        valueX = maxX;
    }
    return valueX;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    _value = [self limitValue:touchPoint.x];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    if (self.touchInside) {
        CGPoint touchPoint = [touch locationInView:self];
        CGFloat x = [self limitValue:touchPoint.x];
        if (x != _value) {
            _value = x;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    _value = [self limitValue:touchPoint.x];
}

@end
