//
//  MNKPDFThumbOperation.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 06.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "MNKPDFEnumList.h"

@class MNKPDFThumbView;

@interface MNKPDFThumbOperation : NSOperation

- (instancetype)initWithGUID:(NSString *)guid pageNumber:(NSUInteger)pageNumber page:(CGPDFPageRef)pageRef size:(MNKPDFThumbSize)size thumbView:(MNKPDFThumbView *)thumbView;

@end
