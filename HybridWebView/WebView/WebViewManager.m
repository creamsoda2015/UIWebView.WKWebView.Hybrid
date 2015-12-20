//
//  WebViewFactory.m
//  WebViewSample
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 test. All rights reserved.
//

#import "WebViewManager.h"

@implementation WebViewManager

static WKProcessPool *_pool = nil;

+ (BOOL)isWKWebViewSupported {
    return [WKWebView class];
}

+ (BOOL)isUIWebViewSupported {
    return [UIWebView class];
}

+ (BOOL)isUseWKWebView {
    if([self isWKWebViewSupported]) {
        return YES;
    }
    return NO;
}

+ (void)fetchUserAgent:(void (^)(NSString* result))completionHandler {
    NSString *uaJs = @"navigator.userAgent";
    if([self isUseWKWebView]) {
        __block WKWebView *webView = [[WKWebView alloc] init];
        [webView evaluateJavaScript:uaJs completionHandler:^(id result, NSError *error) {
            if (error == nil) {
                if (result != nil) {
                    completionHandler([NSString stringWithFormat:@"%@", result]);
                }
            } else {
                NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
            }
            webView = nil;
        }];
    } else {
        UIWebView* webView = [[UIWebView alloc] init];
        completionHandler([webView stringByEvaluatingJavaScriptFromString:uaJs]);
    }
}

// customize webview useragent, need to do before create webview.
+ (void)pushUserAgent:(NSString *)userAgent {
    NSDictionary *defaults = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

+ (id<WebViewProtocol>)createWebView:(CGRect)frame jsPanelController:(UIViewController*)jsPanelController {
    id<WebViewProtocol> webview = nil;
    if ([self isUseWKWebView]) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.processPool = [self pool];
        webview = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        webview.jsPanelController = jsPanelController;
        [webview addDelegate];
    } else {
        webview = [[UIWebView alloc] initWithFrame:frame];
        [webview addDelegate];
    }
    return webview;
}

+ (WKProcessPool *)pool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pool = [[WKProcessPool alloc] init];
    });
    return _pool;
}

@end