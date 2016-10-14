//
//  UIFont+GHFont.h
//  FontChange
//
//  Created by Hank on 16/10/14.
//  Copyright © 2016年 GH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (GHFont)

/**
 设置字体方法

 @param fontSize 字体大小

 @return UIFont
 */
+ (UIFont *)ghFontOfSize:(CGFloat)fontSize;

@end

/**
 这里只是设置了UILable的字体，如果工程项目中有UITextFiled,类似UILable
 */
@interface UILabel (GHFont)

@end
