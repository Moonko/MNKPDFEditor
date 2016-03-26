//
//  MNKPDFDrawingToolbarButton.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 28.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFEnumList.h"

@interface MNKPDFDrawingToolbarButton : UIButton

@property (nonatomic, assign) MNKPDFDrawingToolbarButtonType toolType;

- (instancetype)initWithFrame:(CGRect)frame type:(MNKPDFDrawingToolbarButtonType)type;

@end
