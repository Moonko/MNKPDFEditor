//
//  MNKPDFMainToolbar.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 22.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFMainToolbar.h"
#import "MNKPDFConstants.h"

@interface MNKPDFMainToolbar ()

//@property (nonatomic, strong) UIButton *bookmarkButton;
@property (nonatomic, strong) UIButton *rotateButton;

@end

@implementation MNKPDFMainToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {  
        CGFloat viewWidth = self.bounds.size.width;
        
        CGFloat currentLeftOffset = DEFAULT_SPACING;
        
        NSString *doneButtonText = NSLocalizedString(@"Done", "done");
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGSize doneButtonSize = [doneButtonText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f]}];
        CGFloat doneButtonWidth = doneButtonSize.width + TEXT_BUTTON_PADDING;
        doneButton.frame = CGRectMake(currentLeftOffset, DEFAULT_SPACING,
                                      doneButtonWidth, DEFAULT_BUTTON_SIZE.height);
        [doneButton setTitle:doneButtonText forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(doneButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
        doneButton.exclusiveTouch = YES;
        [self addSubview:doneButton];
        
        currentLeftOffset += doneButton.frame.size.width + DEFAULT_SPACING;
        
        UIButton *thumbsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        thumbsButton.frame = CGRectMake(currentLeftOffset, DEFAULT_SPACING,
                                        DEFAULT_BUTTON_SIZE.width, DEFAULT_BUTTON_SIZE.height);
        [thumbsButton setImage:[UIImage imageNamed:@"Thumbs"] forState:UIControlStateNormal];
        [thumbsButton addTarget:self action:@selector(thumbsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        thumbsButton.exclusiveTouch = YES;
        [self addSubview:thumbsButton];
        
        CGFloat currentRightOffset = viewWidth;
        currentRightOffset -= (DEFAULT_BUTTON_SIZE.width + DEFAULT_SPACING);
        
//        _bookmarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _bookmarkButton.frame = CGRectMake(currentRightOffset, DEFAULT_SPACING,
//                                          DEFAULT_BUTTON_SIZE.width, DEFAULT_BUTTON_SIZE.height);
//        [_bookmarkButton addTarget:self action:@selector(bookmarkButtonTapped)
//                  forControlEvents:UIControlEventTouchUpInside];
//        [_bookmarkButton setImage:[UIImage imageNamed:@"Bookmark"]
//                        forState:UIControlStateNormal];
//        [_bookmarkButton setImage:[UIImage imageNamed:@"Bookmark selected"]
//                        forState:UIControlStateSelected];
//        [self addSubview:_bookmarkButton];
        
        currentRightOffset -= (DEFAULT_BUTTON_SIZE.width + DEFAULT_SPACING);
        
        _rotateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rotateButton.frame = CGRectMake(currentRightOffset, DEFAULT_SPACING, DEFAULT_BUTTON_SIZE.width, DEFAULT_BUTTON_SIZE.height);
        [_rotateButton setImage:[UIImage imageNamed:@"Rotate"] forState:UIControlStateNormal];
        [_rotateButton setImage:[UIImage imageNamed:@"Rotate-highlighted"] forState:UIControlStateHighlighted];
        [_rotateButton addTarget:self action:@selector(rotateButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
        _rotateButton.exclusiveTouch = YES;
        [self addSubview:_rotateButton];
    }
    return self;
}

//- (void)setBookmarkState:(BOOL)state {
//    
//    _bookmarkButton.selected = state;
//}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat currentRightOffset = viewWidth - DEFAULT_SPACING - DEFAULT_BUTTON_SIZE.width;
//    CGRect newBookmarkButtonFrame = _bookmarkButton.frame;
//    newBookmarkButtonFrame.origin.x = currentRightOffset;
//    _bookmarkButton.frame = newBookmarkButtonFrame;
    
//    currentRightOffset -= (DEFAULT_SPACING + DEFAULT_BUTTON_SIZE.width);
    CGRect newRotateButtonFrame = _rotateButton.frame;
    newRotateButtonFrame.origin.x = currentRightOffset;
    _rotateButton.frame = newRotateButtonFrame;
}

- (void)doneButtonTapped {
    
    [self.delegate mainToolbarButtonTappedWithType:MNKPDFMainToolbarButtonTypeDone];
}

- (void)thumbsButtonTapped {
    
    [self.delegate mainToolbarButtonTappedWithType:MNKPDFMainToolbarButtonTypeThumbs];
}

//- (void)bookmarkButtonTapped {
//    
//    _bookmarkButton.selected = !_bookmarkButton.selected;
//    [self.delegate mainToolbarButtonTappedWithType:MNKPDFMainToolbarButtonTypeBookmark];
//}

- (void)rotateButtonTapped {
    
    [self.delegate rotatePage];
}

@end
