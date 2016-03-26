//
//  MNKPDFDrawingToolSettings.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 03/11/15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNKPDFEnumList.h"
#import "MNKPDFDrawingTools.h"

@interface MNKPDFDrawingToolSettings : NSObject

@property (nonatomic, assign) MNKPDFDrawingToolType toolType;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;

+ (instancetype)sharedSettings;

- (id<MNKPDFDrawingTool>)drawingToolWithCurrentSettings;

@end
