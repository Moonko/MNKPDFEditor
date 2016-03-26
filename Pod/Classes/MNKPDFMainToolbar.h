//
//  MNKPDFMainToolbar.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 22.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFToolbarView.h"
#import "MNKPDFEnumList.h"

@protocol MNKPDFMainToolbarDelegate <NSObject>

@required

- (void)mainToolbarButtonTappedWithType:(MKPDFMainToolbarButtonType)buttonType;
- (void)rotatePage;

@end

@class MNKPDFDocument;

@interface MNKPDFMainToolbar : MNKPDFToolbarView

@property (nonatomic, weak, readwrite) id<MNKPDFMainToolbarDelegate> delegate;

//- (void)setBookmarkState:(BOOL)state;

@end
