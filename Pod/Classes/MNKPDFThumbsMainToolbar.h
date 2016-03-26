//
//  MNKPDFThumbsMainToolbar.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 07.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFToolbarView.h"

@class MNKPDFThumbsMainToolbar;

@protocol MNKPDFThumbsMainToolbarDelegate <NSObject>

- (void)tappedInToolbar:(MNKPDFThumbsMainToolbar *)toolbar doneButton:(UIButton *)button;
- (void)tappedInToolbar:(MNKPDFThumbsMainToolbar *)toolbar showControl:(UISegmentedControl *)control;

@end

@interface MNKPDFThumbsMainToolbar : MNKPDFToolbarView

@property (nonatomic, weak) id<MNKPDFThumbsMainToolbarDelegate> delegate;

@end
