//
//  MNKPDFContentPage.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 21.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNKPDFContentPage : UIView

@property (nonatomic, readonly) NSUInteger pageNumber;

- (instancetype)initWithPage:(CGPDFPageRef)page number:(NSUInteger)number angle:(NSUInteger)angle;

@end
