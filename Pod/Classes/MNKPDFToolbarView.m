//
//  MNKPDFToolbarView.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 29.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFToolbarView.h"

@implementation MNKPDFToolbarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        CGRect lineRect = CGRectInset(self.bounds, -1.0f, -1.0f);
        
        UIView *lineView = [[UIView alloc] initWithFrame:lineRect];
        lineView.autoresizesSubviews = NO;
        lineView.userInteractionEnabled = NO;
        lineView.contentMode = UIViewContentModeRedraw;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lineView.backgroundColor = [UIColor clearColor];
        lineView.layer.borderColor = [UIColor grayColor].CGColor;
        lineView.layer.borderWidth = 1.0f;
        [self addSubview:lineView];
    }
    return self;
}

- (void)hide {
    
    if (!self.hidden) {
        [UIView animateWithDuration:0.25f delay:0.0f
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.alpha = 0.0f;
                         }completion:^(BOOL completed){
                             self.hidden = YES;
                         }];
    }
}

- (void)show {
    
    if (self.hidden) {
        [UIView animateWithDuration:0.25f delay:0.0f
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.hidden = NO;
                             self.alpha = 1.0f;
                         }completion:nil];
    }
}

@end
