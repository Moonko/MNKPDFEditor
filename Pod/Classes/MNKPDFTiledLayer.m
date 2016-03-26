//
//  MNKPDFTiledLayer.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 20.10.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFTiledLayer.h"
#import "MNKPDFConstants.h"

@implementation MNKPDFTiledLayer

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.levelsOfDetail = LEVELS_OF_DETAIL;
        self.levelsOfDetailBias = LEVELS_OF_DETAIL - 1;
        self.tileSize = DEFAULT_TILE_SIZE;
    }
    return self;
}

@end
