
//
//  MNKPDFThumbsMainToolbar.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 07.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFThumbsMainToolbar.h"

#define DEFAULT_SPACING 8.0f
#define BUTTON_EDGE 30.0f
#define TEXT_BUTTON_PADDING 20.0f

@interface MNKPDFThumbsMainToolbar ()

@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *rotateButton;

@end

@implementation MNKPDFThumbsMainToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        NSString *doneButtonText = NSLocalizedString(@"Done", "button");
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGSize doneButtonSize = [doneButtonText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
        CGFloat doneButtonWidth = doneButtonSize.width + TEXT_BUTTON_PADDING;
        doneButton.frame = CGRectMake(DEFAULT_SPACING,
                                      self.bounds.size.height - DEFAULT_SPACING - BUTTON_EDGE,
                                      doneButtonWidth, BUTTON_EDGE);
        [doneButton setTitle:doneButtonText forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneButtonTapped:)
             forControlEvents:UIControlEventTouchUpInside];
        doneButton.exclusiveTouch = YES;
        [self addSubview:doneButton];
    }
    return self;
}

- (void)doneButtonTapped:(UIButton *)sender {
    
    [self.delegate tappedInToolbar:self doneButton:sender];
}

@end
