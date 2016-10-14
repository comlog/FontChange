//
//  GHFontManager.m
//  FontChange
//
//  Created by Hank on 16/10/14.
//  Copyright © 2016年 GH. All rights reserved.
//

#import "GHFontManager.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CTFontManager.h>

@implementation GHFontManager
+(GHFontManager *)sharedFontManager{
    static GHFontManager *fontManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fontManager = [[GHFontManager alloc] init];
    });
    return fontManager;
}

-(NSString *)loadFontAndGetFontPostScriptName:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data == nil) {
        NSLog(@"字体文件读取失败.  路径 %@ ", path);
        return nil;
    }
    CFErrorRef errorRef;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    NSString *realFontName = (__bridge_transfer NSString *)CGFontCopyPostScriptName(font);
    if (!CTFontManagerRegisterGraphicsFont(font, &errorRef)) {
        NSError *error = (__bridge NSError *)errorRef;
        if (error.code != kCTFontManagerErrorAlreadyRegistered) {
            NSLog(@"加载字体到内存失败: %@", error);
        }
    }
    NSLog(@"Real font name: %@", realFontName);
    if (font != nil) {
        CFRelease(font);
    }
    CFRelease(provider);
    
    return realFontName;
}

-(NSString *)revertToAbsoluteFilePath:(NSString *)relativePath{
    
    return [[self documentsPath] stringByAppendingPathComponent:relativePath];
}

- (NSString*)documentsPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths.firstObject;
    return path;
}


-(BOOL)copyFileToDocuments:(NSString *)docPath andDocumentsFileName:(NSString *)documentsFileName
{
    // 沙盒Documents目录
    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    NSString *appLib = [appDir stringByAppendingString:documentsFileName];
    
    //新建文件夹
    if(![[NSFileManager defaultManager] fileExistsAtPath:appLib])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:appLib
                                  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL filesPresent = [self copyMissingFile:docPath toPath:appLib];
    return filesPresent;
}


/**
 复制文件到沙盒

 @param sourcePath 资源文件目录
 @param toPath     把文件拷贝到XXX文件夹

 @return BOOL
 */
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        NSError  *error;
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:&error];
        NSLog(@"copyMissingFileError====%@",error);
    }
    return retVal;
}
@end
