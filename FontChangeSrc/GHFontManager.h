//
//  GHFontManager.h
//  FontChange
//
//  Created by Hank on 16/10/14.
//  Copyright © 2016年 GH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GHFontManager : NSObject

/**
 字体名称
 */
@property (nonatomic,copy) NSString *fontName;


/**
 字体的路径，可以是NSBundle中，可以是沙盒中
 */
@property (nonatomic,copy) NSString *fontFilePath;

+(GHFontManager *)sharedFontManager;


/**
 从字体库路径读取字体名称

 @param path 字体库路径

 @return NSString
 */
-(NSString *)loadFontAndGetFontPostScriptName:(NSString *)path;


/**
 沙盒目录拼接
 */
-(NSString *)revertToAbsoluteFilePath:(NSString *)relativePath;


/**
 文件复制
 */
-(BOOL)copyFileToDocuments:(NSString*)docPath andDocumentsFileName:(NSString*)documentsFileName;

@end
