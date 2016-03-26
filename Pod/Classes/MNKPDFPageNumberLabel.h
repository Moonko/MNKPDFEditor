//
//  MNKPDFPageNumberLabel.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 25.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  MNKPDFDocument;

@interface MNKPDFPageNumberLabel : UILabel

- (instancetype)initWithFrame:(CGRect)frame document:(MNKPDFDocument *)document;

@property (nonatomic, assign, readwrite) NSUInteger pageNumber;

@end