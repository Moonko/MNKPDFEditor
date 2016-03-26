//
//  MNKPDFMainPagebar.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 25.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFToolbarView.h"

@class MNKPDFDocument;

@protocol MNKPDFMainPagebarDelegate <NSObject>

@required

- (void)pageChosen:(NSUInteger)page;

@end

@interface MNKPDFMainPagebar : MNKPDFToolbarView

@property (nonatomic, weak) id<MNKPDFMainPagebarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame document:(MNKPDFDocument *)document;

- (void)update;

@end
