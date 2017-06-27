//
//  CoretextVC.m
//  TDFDemo
//
//  Created by 汤丹峰 on 2017/6/12.
//  Copyright © 2017年 tangdanfeng. All rights reserved.
//

#import "CoretextVC.h"
#import "CTDisplayView.h"
#import "CTFrameParser.h"
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@interface CoretextVC ()

@end

@implementation CoretextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CoreText";
    
    //CoreText 和 UIWebView 优缺点
    //基于 CoreText 来排版需要自己处理很多复杂逻辑，例如需要自己处理图片与文字混排相关的逻辑，也需要自己实现链接点击操作的支持 占用的内存更少，渲染速度快，UIWebView 占用的内存更多，渲染速度慢
    //CoreText 在渲染界面前就可以精确地获得显示内容的高度（只要有了 CTFrame 即可），而 UIWebView 只有渲染出内容后，才能获得内容的高度（而且还需要用 javascript 代码来获取）
    //CoreText 的 CTFrame 可以在后台线程渲染，UIWebView 的内容只能在主线程（UI 线程）渲染
    //基于 CoreText 可以做更好的原生交互效果，交互效果可以更细腻。而 UIWebView 的交互效果都是用 javascript 来实现的，在交互效果上会有一些卡顿存在
    
    //CoreText 渲染出来的内容不能像 UIWebView 那样方便地支持内容的复制
    //基于 CoreText 来排版需要自己处理很多复杂逻辑，例如需要自己处理图片与文字混排相关的逻辑，也需要自己实现链接点击操作的支持
    
    CTDisplayView *ctView = [[CTDisplayView alloc] initWithFrame:CGRectMake(10, 0, mainWidth-20, 100)];
    [self.view addSubview:ctView];
    ctView.backgroundColor = [UIColor whiteColor];
    
    CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
    config.width = ctView.width;
    
    CoreTextData *data = [CTFrameParser parseTemplateFile:@"coretext.plist" config:config];
    ctView.data = data;
    ctView.height = data.height;
}

@end
