//
//  MNKPDFPageTrackControl.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 25.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNKPDFPageTrackControl : UIControl

@property (nonatomic, assign, readonly) CGFloat value;
@property (nonatomic, assign) NSUInteger currentPageIndex;

@end
