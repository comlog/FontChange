//
//  ViewController.m
//  FontChange
//
//  Created by Hank on 16/10/14.
//  Copyright © 2016年 GH. All rights reserved.
//

#import "ViewController.h"
#import "GHFontManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor =[UIColor whiteColor];
    

    
    UIButton *changeTheFont = [UIButton buttonWithType:UIButtonTypeCustom];
    changeTheFont.frame = CGRectMake(100, 100, 250, 100);
    [changeTheFont setTitle:@"网络下载字体——fzlt_thin" forState:UIControlStateNormal];
    [changeTheFont addTarget:self action:@selector(downloadFontFromService) forControlEvents:UIControlEventTouchUpInside];
    [changeTheFont setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:changeTheFont];
    
    changeTheFont = [UIButton buttonWithType:UIButtonTypeCustom];
    changeTheFont.frame = CGRectMake(100, 250, 250, 100);
    [changeTheFont setTitle:@"系统字体" forState:UIControlStateNormal];
    [changeTheFont setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeTheFont addTarget:self action:@selector(changeSystemFont) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeTheFont];
    
    changeTheFont = [UIButton buttonWithType:UIButtonTypeCustom];
    changeTheFont.frame = CGRectMake(10, 400, 350, 100);
    [changeTheFont setTitle:@"Bundle文件字体——Amano.ttf字体" forState:UIControlStateNormal];
    [changeTheFont setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeTheFont addTarget:self action:@selector(changeFzlt_thinFont) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:changeTheFont];
    
    
    UILabel *showFontLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 500, 300, 60)];
    showFontLbl.text =@"在这里展示将要修改的字体";
    showFontLbl.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:showFontLbl];

    
}


- (void)downloadFontFromService {
   //网络下载字体 这里模拟从 NSBundle 复制到沙盒 ，
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"fzlt_thin.ttf" ofType:nil];
    [[GHFontManager sharedFontManager]copyFileToDocuments:docPath andDocumentsFileName:@"/Font"];
    
    [GHFontManager sharedFontManager].fontFilePath =[[GHFontManager sharedFontManager] revertToAbsoluteFilePath:@"/Font/fzlt_thin.ttf"];
    
    [GHFontManager sharedFontManager].fontName =[[GHFontManager sharedFontManager] loadFontAndGetFontPostScriptName:[GHFontManager sharedFontManager].fontFilePath];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSTEMFONTCHANGENOTIFICATIONNAME" object:nil];

}

- (void)changeSystemFont {
    [GHFontManager sharedFontManager].fontName =nil;
    [GHFontManager sharedFontManager].fontFilePath =nil;

    //系统字体
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSTEMFONTCHANGENOTIFICATIONNAME" object:nil];

}
- (void)changeFzlt_thinFont {
    //woziku-bsdsm-CN4262字体

    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"Wzk.ttf" ofType:nil];
    [GHFontManager sharedFontManager].fontName =[[GHFontManager sharedFontManager] loadFontAndGetFontPostScriptName:docPath];
    [GHFontManager sharedFontManager].fontFilePath =docPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SYSTEMFONTCHANGENOTIFICATIONNAME" object:nil];
}
@end
