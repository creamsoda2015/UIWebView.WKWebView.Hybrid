//
//  WebViewFactory.h
//  WebViewSample
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebViewProtocol.h"
#import "UIWebView+Custom.h"
#import "WKWebView+Custom.h"

@interface WebViewManager : NSObject;

+ (BOOL)isWKWebViewSupported;
+ (BOOL)isUIWebViewSupported;
+ (BOOL)isUseWKWebView;
+ (id<WebViewProtocol>)createWebView:(CGRect)frame jsPanelController:(UIViewController*)jsPanelController;

+ (WKProcessPool *)pool;

+ (void)fetchUserAgent:(void (^)(NSString* result))completionHandler;
+ (void)pushUserAgent:(NSString *)userAgent;
    
@end