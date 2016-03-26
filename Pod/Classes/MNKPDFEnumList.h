//
//  MNKPDFEnumList.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 29.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#ifndef MNKPDFEnumList_h
#define MNKPDFEnumList_h

typedef NS_ENUM(NSInteger, MKPDFMainToolbarButtonType) {
    
    MNKPDFMainToolbarButtonTypeDone,
    MNKPDFMainToolbarButtonTypeThumbs,
    MNKPDFMainToolbarButtonTypeBookmark
};

typedef NS_ENUM(NSInteger, MNKPDFThumbSize) {
    
    MNKPDFThumbSizeSmall,
    MNKPDFThumbSizeMedium,
    MNKPDFThumbSizeLarge
};

typedef NS_ENUM(NSInteger, MNKPDFDrawingToolType) {
    
    MNKPDFDrawingToolTypePen,
    MNKPDFDrawingToolTypeLine,
    MNKPDFDrawingToolTypeEllipseFilled,
    MNKPDFDrawingToolTypeEllipseStroked,
    MNKPDFDrawingToolTypeRectangleFilled,
    MNKPDFDrawingToolTypeRectangleStroked,
    MNKPDFDrawingToolTypeEraser
};

typedef NS_ENUM(NSInteger, MNKPDFDrawingToolbarButtonType) {
    
    MNKPDFDrawingToolbarButtonTypePen,
    MNKPDFDrawingToolbarButtonTypeLine,
    MNKPDFDrawingToolbarButtonTypeEllipseFilled,
    MNKPDFDrawingToolbarButtonTypeEllipseStroked,
    MNKPDFDrawingToolbarButtonTypeRectangleFilled,
    MNKPDFDrawingToolbarButtonTypeRectangleStroked,
    MNKPDFDrawingToolbarButtonTypeEraser,
    
    MNKPDFDrawingToolbarButtonTypeUndo,
    MNKPDFDrawingToolbarButtonTypeRedo,
    MNKPDFDrawingToolbarButtonTypeClear,
    MNKPDFDrawingToolbarButtonTypePalette
};

#endif /* MNKPDFEnumList_h */
