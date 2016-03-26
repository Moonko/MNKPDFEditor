//
//  MNKPDFDocument.m
//  MNKPDFEditor
//
//  Created by Андрей Рычков on 15.11.15.
//  Copyright © 2015 Ninenone. All rights reserved.
//

#import "MNKPDFDocument.h"
#import <QuartzCore/QuartzCore.h>

@interface MNKPDFDocument ()

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) NSUInteger pageCount;

@end

@implementation MNKPDFDocument

+ (NSString *)documentsInfoPath {
    
    static dispatch_once_t predicate;
    static NSString *documentsInfoPath;
    
    dispatch_once(&predicate, ^{
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
        documentsInfoPath = [documentsDirectory stringByAppendingPathComponent:@"documentsInfo.mnkpdf"];
    });
    
    return documentsInfoPath;
}

+ (NSMutableDictionary *)documentsInfo {
    
    static dispatch_once_t predicate;
    static NSMutableDictionary *documentsInfo;
    
    dispatch_once(&predicate, ^{
        NSString *documentsInfoPath = [self documentsInfoPath];
        documentsInfo = [NSMutableDictionary dictionaryWithContentsOfFile:documentsInfoPath];
        if (!documentsInfo) {
            documentsInfo = [NSMutableDictionary dictionary];
        }
    });
    
    return documentsInfo;
}

+ (NSString *)guid {
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    NSString *uniqueString = (__bridge NSString *)uuidString;
    CFRelease(uuid);
    CFRelease(uuidString);
    
    return uniqueString;
}

+ (BOOL)isPDF:(NSString *)filePath {
    
    BOOL isPDF = NO;
    if (filePath != nil) {
        const char *path = [filePath fileSystemRepresentation];
        int fileDesctiptor = open(path, O_RDONLY);
        if (fileDesctiptor > 0) {
            const char signature[1024];
            ssize_t length = read(fileDesctiptor, (void *)&signature, sizeof(signature));
            isPDF = (strnstr(signature, "%PDF", length) != NULL);
            close(fileDesctiptor);
        }
    }
    return isPDF;
}

- (void)save {
    
    [MNKPDFDocument documentsInfo][self.filePath] = [self toPropertiesDictionary];
    BOOL saved = [[MNKPDFDocument documentsInfo] writeToFile:[MNKPDFDocument documentsInfoPath] atomically:YES];
    NSLog(@"%i", saved);
}

- (void)remove {
    
    [MNKPDFDocument documentsInfo][self.filePath] = nil;
    [[MNKPDFDocument documentsInfo] writeToFile:[MNKPDFDocument documentsInfoPath] atomically:YES];
}

- (NSDictionary *)toPropertiesDictionary {
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"filePath"] = self.filePath;
    properties[@"lastOpenedPageIndex"] = @(self.lastOpenedPageIndex);
    properties[@"bookmarks"] = self.bookmarks;
    properties[@"timestamp"] = self.timestamp;
    properties[@"fileName"] = self.fileName;
    properties[@"guid"] = self.guid;
    
    return properties;
}

+ (MNKPDFDocument *)fromPropertiesDictionary:(NSDictionary *)properties {
    
    if (!properties) {
        return nil;
    }
    MNKPDFDocument *document = [[MNKPDFDocument alloc] init];
    document.filePath = properties[@"filePath"];
    document.lastOpenedPageIndex = [properties[@"lastOpenedPageIndex"] integerValue];
    document.bookmarks = properties[@"bookmarks"];
    document.timestamp = properties[@"timestamp"];
    document.fileName = properties[@"fileName"];
    document.guid = properties[@"guid"];
    
    return document;
}

+ (MNKPDFDocument *)documentWithFilePath:(NSString *)filePath {
    
    MNKPDFDocument *document = nil;
    if ([self isPDF:filePath]) {
        
        document = [MNKPDFDocument fromPropertiesDictionary:[self documentsInfo][filePath]];
        
        NSString *fileName = [filePath lastPathComponent];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        NSDictionary *fileAttributes = [defaultManager attributesOfItemAtPath:filePath
                                                                        error:nil];
        NSDate *fileModificationDate = [fileAttributes fileModificationDate];
        
        if (!document || ![fileModificationDate isEqualToDate:document.timestamp]) {
            document = [[MNKPDFDocument alloc] init];
            document.filePath = filePath;
            document.lastOpenedPageIndex = 0;
            document.bookmarks = [NSMutableArray array];
            document.timestamp = fileModificationDate;
            document.fileName = fileName;
            document.guid = [MNKPDFDocument guid];
            [document createDirectory];
        }
        
        CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)document.fileURL);
        
        document.pageCount = CGPDFDocumentGetNumberOfPages(documentRef);
        document.pages = [NSMutableArray array];
        document.angles = [NSMutableArray array];
        for (NSUInteger page = 1; page <= document.pageCount; page++) {
            [document.angles addObject:@(0)];
            [document.pages addObject:@(page)];
        }
        CGPDFDocumentRelease(documentRef);
    }
    return document;
}

- (NSString *)imagePathForPage:(NSUInteger)page {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    NSString *appendingString = [NSString stringWithFormat:@"%@/%lu.png", self.guid, (unsigned long)page];
    return [documentsDirectory stringByAppendingPathComponent:appendingString];
}

- (void)createDirectory {
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[self pdfDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
}

- (NSString *)pdfDirectory {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
    return [documentsDirectory stringByAppendingPathComponent:self.guid];
}

- (NSURL *)fileURL {
    
    return [NSURL fileURLWithPath:self.filePath];
}

@end
