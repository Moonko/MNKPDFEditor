//
//  MNKPDFPaletteController.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 13.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MNKPDFPaletteViewControllerMode) {
    MNKPDFPaletteViewControllerModePopover,
    MNKPDFPaletteViewControllerModeModal
};

@interface MNKPDFPaletteViewController : UIViewController

@property (nonatomic, assign) MNKPDFPaletteViewControllerMode mode;

@end
