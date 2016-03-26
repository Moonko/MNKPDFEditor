//
//  MNKPDFDrawingToolbar.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 28.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFToolbarView.h"

@class MNKPDFDrawingToolbarButton;

@protocol MNKPDFDrawingToolbarDelegate <NSObject>

- (void)drawingToolbarButtonTapped:(MNKPDFDrawingToolbarButton *)button;

@end

@interface MNKPDFDrawingToolbar : MNKPDFToolbarView

@property (nonatomic, weak) id<MNKPDFDrawingToolbarDelegate> delegate;

@end
