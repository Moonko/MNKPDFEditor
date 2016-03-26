//
//  MNKPDFThumbView.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 06.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFEnumList.h"
#import "MNKPDFConstants.h"

@interface MNKPDFThumbView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame angle:(NSUInteger)angle;

- (void)renderThumbWithFrame:(CGRect)frame documentGUID:(NSString *)guid pageNumber:(NSUInteger)pageNumber page:(CGPDFPageRef)pageRef thumbSize:(MNKPDFThumbSize)thumbSize;

@end
