//
//  MNKPDFDrawingToolbar.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 28.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingToolbar.h"
#import "MNKPDFDrawingToolbarButton.h"
#import "MNKPDFConstants.h"
#import "UIImage_MNKPDFEditorBundle.h"

@interface MNKPDFDrawingToolbar ()

@property (nonatomic, weak) MNKPDFDrawingToolbarButton *selectedButton;

@end

@implementation MNKPDFDrawingToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingNone;
        
        CGFloat offsetTop = DEFAULT_SPACING;
        CGFloat offsetShift = DEFAULT_SPACING + DEFAULT_BUTTON_SIZE.height;
        
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypePen image:[UIImage MNKPDFEditorImageNamed:@"Pen"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeLine image:[UIImage MNKPDFEditorImageNamed:@"Line"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeEllipseFilled image:[UIImage MNKPDFEditorImageNamed:@"Circle-Filled"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeEllipseStroked image:[UIImage MNKPDFEditorImageNamed:@"Circle-Stroked"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeRectangleFilled image:[UIImage MNKPDFEditorImageNamed:@"Square-Filled"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeRectangleStroked image:[UIImage MNKPDFEditorImageNamed:@"Square-Stroked"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeEraser image:[UIImage MNKPDFEditorImageNamed:@"Eraser"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypePalette image:[UIImage MNKPDFEditorImageNamed:@"Palette"] highlightedImage:nil offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeUndo image:[UIImage MNKPDFEditorImageNamed:@"Undo"] highlightedImage:[UIImage MNKPDFEditorImageNamed:@"Undo-Highlighted"] offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeRedo image:[UIImage MNKPDFEditorImageNamed:@"Redo"] highlightedImage:[UIImage MNKPDFEditorImageNamed:@"Redo-Highlighted"] offset:offsetTop];
        offsetTop += offsetShift;
        [self createToolbarButtonWithType:MNKPDFDrawingToolbarButtonTypeClear image:[UIImage MNKPDFEditorImageNamed:@"Clear"] highlightedImage:nil offset:offsetTop];
    }
    return self;
}

- (void)createToolbarButtonWithType:(MNKPDFDrawingToolbarButtonType)type image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage offset:(CGFloat)offset {
    
    CGRect buttonFrame = CGRectMake(DEFAULT_SPACING, offset, DEFAULT_BUTTON_SIZE.width, DEFAULT_BUTTON_SIZE.height);
    MNKPDFDrawingToolbarButton *button = [[MNKPDFDrawingToolbarButton alloc] initWithFrame:buttonFrame type:type];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(toolbarButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)toolbarButtonTapped:(MNKPDFDrawingToolbarButton *)button {
    
    if (button.toolType != MNKPDFDrawingToolbarButtonTypeUndo &&
        button.toolType != MNKPDFDrawingToolbarButtonTypeRedo &&
        button.toolType != MNKPDFDrawingToolbarButtonTypeClear &&
        button.toolType != MNKPDFDrawingToolbarButtonTypePalette) {
        if (_selectedButton != button) {
            _selectedButton.selected = false;
            _selectedButton.backgroundColor = [UIColor clearColor];
            _selectedButton = button;
        }
        button.selected = !button.selected;
        button.backgroundColor = button.selected ? [UIColor grayColor] : [UIColor clearColor];
    }
    [self.delegate drawingToolbarButtonTapped:button];
}

@end
