//
//  MNKPDFThumbCell.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 06.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNKPDFEnumList.h"

@interface MNKPDFThumbCell : UICollectionViewCell

@property (nonatomic, assign) NSUInteger angle;

- (void)renderThumbWithDocumentGUID:(NSString *)guid pageNumber:(NSUInteger)pageNumber page:(CGPDFPageRef)pageRef thumbSize:(MNKPDFThumbSize)thumbSize;

@end
