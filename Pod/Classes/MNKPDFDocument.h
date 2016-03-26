//
//  MNKPDFDocument.h
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 15.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNKPDFDocument : NSObject

@property (nonatomic, strong) NSMutableArray *bookmarks;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign, readonly) NSUInteger pageCount;
@property (nonatomic, strong) NSString *guid;
@property (nonatomic, strong) NSMutableArray *angles;
@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, assign) NSUInteger lastOpenedPageIndex;

+ (MNKPDFDocument *)documentWithFilePath:(NSString *)filePath;

- (NSURL *)fileURL;
- (NSString *)pdfDirectory;

- (void)save;
- (void)remove;

- (NSString *)imagePathForPage:(NSUInteger)page;

@end
