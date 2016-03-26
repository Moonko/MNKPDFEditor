//
//  MNKPDFDrawingToolCircle.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 02/11/15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDrawingTool.h"

@interface MNKPDFDrawingToolEllipse : NSObject
<MNKPDFDrawingTool>

@property (nonatomic, assign, getter=isFilled) BOOL filled;

@end
