//
//  UIImage_MNKPDFEditorBundle.m
//  Pods
//
//  Created by Rychkov Andrei on 26/03/16.
//
//

#import <Foundation/Foundation.h>
#import "UIImage_MNKPDFEditorBundle.h"
#import "MNKPDFDocument.h"

@implementation UIImage (MNKPDFEditorBundle)

+ (UIImage *)MNKPDFEditorImageNamed:(NSString *)name; {
    NSString *bundlePath = [[NSBundle bundleForClass:[MNKPDFDocument class]] pathForResource:@"MNKPDFEditor" ofType:@"bundle"];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:bundlePath];
    
    return [UIImage imageNamed:name inBundle:resourcesBundle compatibleWithTraitCollection:nil];
}

@end
