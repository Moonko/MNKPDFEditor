//
//  MNKPDFDrawingTool.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 27.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MNKPDFDrawingTool <NSObject>

@required

@property (nonatomic, strong, readwrite) UIColor *lineColor;
@property (nonatomic, assign, readwrite) CGFloat lineAlpha;
@property (nonatomic, assign, readwrite) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)initialPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;

@end
