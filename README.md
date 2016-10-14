# FontChange
iOS FontChange

iOS 利用runtime 实现全局字体的改变

创建UIFont的类别
  UIFont+GHFont.h,UIFont+GHFont.m
  
  + (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /*利用runtime 实现当调用系统systemFontOfSize:获取字体的时候，调用指定的方法ghFontOfSize 从而重新设置字体*/
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
