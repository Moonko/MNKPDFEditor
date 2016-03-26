//
//  MNKPDFPageNumberLabel.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 25.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFPageNumberLabel.h"
#import "MNKPDFDocument.h"

@interface MNKPDFPageNumberLabel ()

@property (nonatomic, strong) MNKPDFDocument *document;

@end

@implementation MNKPDFPageNumberLabel

- (instancetype)initWithFrame:(CGRect)frame document:(MNKPDFDocument *)document {
    
    self = [super initWithFrame:frame];
    if (self) {
        _document = document;
        self.pageNumber = [_document.pages[_document.lastOpenedPageIndex] integerValue];
        
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:16.0f];
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumScaleFactor = 0.75f;
    }
    return self;
}

- (void)setPageNumber:(NSUInteger)pageNumber {
    
    if (pageNumber != self.pageNumber) {
        NSUInteger pageCount = _document.pageCount;
        NSString *formatString = NSLocalizedString(@"%i of %i", @"format");
        NSString *numberString = [[NSString alloc]
                                  initWithFormat:formatString, (uint)pageNumber, (uint)pageCount];
        self.text = numberString;
    }
}

@end
