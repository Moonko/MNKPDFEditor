//
//  MNKPDFDrawingToolbarButton.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 28.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolbarButton.h"

@implementation MNKPDFDrawingToolbarButton

- (instancetype)initWithFrame:(CGRect)frame type:(MNKPDFDrawingToolbarButtonType)type {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.toolType = type;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.exclusiveTouch = YES;
    }
    return self;
}

@end
