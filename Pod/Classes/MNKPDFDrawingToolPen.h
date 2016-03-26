//
//  MNKPDFDrawingToolPen.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 27.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingTool.h"

@interface MNKPDFDrawingToolPen : NSObject
<MNKPDFDrawingTool>

@property (nonatomic, assign, readonly) CGRect boxNeedsToDisplay;

@property (nonatomic, assign, readonly) CGMutablePathRef path;

@end
