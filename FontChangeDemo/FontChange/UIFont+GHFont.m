//
//  UIFont+GHFont.m
//  FontChange
//
//  Created by Hank on 16/10/14.
//  Copyright © 2016年 GH. All rights reserved.
//

#import "UIFont+GHFont.h"
#import <CoreText/CTFont.h>
#import <objc/runtime.h>
#import "GHFontManager.h"
#import "NSObject+Swizzle.h"

//默认字体
static NSString *kDefultFontName_GH = nil;

@implementation UIFont (GHFont)


+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        kDefultFontName_GH = [UIFont systemFontOfSize:10].fontName;
        Class class = [self class];
        Method originalMethod = class_getClassMethod(class, @selector(systemFontOfSize:));
        Method swizzledMethod = class_getClassMethod(class, @selector(ghFontOfSize:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    });
}

+ (UIFont *)ghFontOfSize:(CGFloat)fontSize {

    GHFontManager *manager = [GHFontManager sharedFontManager];
    NSString *fontName = manager.fontName;    
    if (fontName == nil) {
        fontName = kDefultFontName_GH;
    }
    return [UIFont fontWithName:fontName  size:fontSize];
}

@end

@implementation UILabel (GHFont)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UILabel swizzleMethods:[self class] originalSelector:@selector(initWithFrame:) swizzledSelector:@selector(swiz_initWithFrame:)];
        [UILabel swizzleMethods:[self class] originalSelector:@selector(initWithCoder:) swizzledSelector:@selector(swiz_initWithCoder:)];
        [UILabel swizzleMethods:[self class] originalSelector:NSSelectorFromString(@"dealloc") swizzledSelector:@selector(swiz_dealloc)];
    });
}


#pragma mark --Swizzle
- (instancetype)swiz_initWithFrame:(CGRect)frame {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontChanged) name:@"SYSTEMFONTCHANGENOTIFICATIONNAME" object:nil];
    return [self swiz_initWithFrame:frame];
}

- (instancetype)swiz_initWithCoder:(NSCoder *)aDecoder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontChanged) name:@"SYSTEMFONTCHANGENOTIFICATIONNAME" object:nil];
    return [self swiz_initWithCoder:aDecoder];
}

- (void)swiz_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SYSTEMFONTCHANGENOTIFICATIONNAME" object:nil];
    [self swiz_dealloc];
}

#pragma mark --Notification
- (void)fontChanged {

    CTFontRef font = CTFontCreateWithName((CFStringRef)self.font.fontName,self.font.pointSize, NULL);
    CTFontSymbolicTraits traits = CTFontGetSymbolicTraits(font);
    if (font != nil) {
        CFRelease(font);
    }
    BOOL isBold = ((traits & kCTFontBoldTrait) == kCTFontBoldTrait);
    if (!isBold) {
        self.font = [UIFont systemFontOfSize:self.font.pointSize];
    }
    
}

@end
