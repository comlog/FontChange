//
//  NSObject+Swizzle.h
//  FontChange
//
//  Created by Hank on 16/10/14.
//  Copyright © 2016年 GH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)
- (void)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;

+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel;

@end
