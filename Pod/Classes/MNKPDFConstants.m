//
//  MNKPDFConstants.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 11.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFConstants.h"

#pragma mark – Spacing and sizes

const CGFloat DEFAULT_SPACING = 8.0f;
const CGSize DEFAULT_BUTTON_SIZE = {30.0f, 30.0f};
const CGFloat TEXT_BUTTON_PADDING = 20.0f;
const CGFloat STATUS_BAR_HEIGHT = 20.0f;

#pragma mark – Tile properties

const size_t LEVELS_OF_DETAIL = 16;
const CGSize DEFAULT_TILE_SIZE = {1024.0f, 1024.0f};

#pragma mark – Pagebar properties

const CGFloat PAGE_NUMBER_SPACE = 8.0f;
const CGFloat PAGE_NUMBER_WIDTH = 96.0f;
const CGFloat PAGE_NUMBER_HEIGHT = 30.0f;

const CGFloat THUMB_SMALL_GAP = 2.0f;
const CGFloat THUMB_SMALL_WIDTH = 22.0f;
const CGFloat THUMB_SMALL_HEIGHT = 28.0f;

const CGFloat THUMB_LARGE_WIDTH = 32.0f;
const CGFloat THUMB_LARGE_HEIGHT = 42.0f;

#pragma mark – Toolbars properties

const CGFloat MAIN_TOOLBAR_HEIGHT = 46.0f;

const CGFloat PAGEBAR_HEIGHT = 48.0f;

const CGFloat DRAWING_TOOLBAR_WIDTH = 46.0f;
const CGFloat DRAWING_TOOLBAR_HEIGHT = 426.0f;

#pragma mark – Content page properties

const CGFloat MAXIMUM_SCALE = 16.0f;
const CGFloat SCALE_FACTOR = 4.0f;

#pragma mark – Drawing view defaults

const CGFloat LINE_WIDTH = 10.0f;
const CGFloat LINE_ALPHA = 1.0f;

#pragma mark – Thumbs view properties

const size_t THUMBS_IN_ROW_PORTRAIT  = 3;
const size_t THUMBS_IN_ROW_LANDSCAPE = 4;

#pragma mark – Palette properties

const CGFloat PALETTE_WIDTH = 300.0f;
const CGFloat PALETTE_HEIGHT = 300.0f;

const CGFloat MINIMUM_LINE_WIDTH = 2.0f;
const CGFloat MAXIMUM_LINE_WIDTH = 30.0f;
const CGSize PALETTE_BUTTON_SIZE = {40.0f, 40.0f};

#pragma mark – Degrees to Radians

float degreesToRadians(float degrees) {
    return degrees * M_PI / 180.0f;
}

float radiansToDegrees(float radians) {
    return radians * 180.0f / M_PI;
}
