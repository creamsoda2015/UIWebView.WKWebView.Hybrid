//
//  UIWebView+Custom.h
//  WebViewSample
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 test. All rights reserved.
//

#import <objc/runtime.h>

#import <UIKit/UIKit.h>
#import "WebViewProtocol.h"

@interface UIWebView (Custom) <WebViewProtocol, UIWebViewDelegate>

@property (nonatomic, nullable) id<WebViewDelegate> webViewDelegate;
@property (nonatomic) BOOL scalesPageToFit;
@property (nonatomic, nullable) NSURL *currentURL;
@property (nonatomic, nullable) NSString *customUA;
@property (nonatomic, nullable) UIViewController *jsPanelController;

- (void)addDelegate;
- (void)scrollBounceEnabled:(BOOL)enabled;
- (void)scrollBarShow:(BOOL)isShow;
- (void)setScalesPageToFit:(BOOL)scalesPageToFit;
- (void)setCustomUA:(nullable NSString *)ua;
- (void)loadLocalData:(nullable NSData *)data MIMEType:(nullable NSString *)MIMEType textEncodingName:(nullable NSString *)textEncodingName baseURL:(nullable NSURL *)baseURL fileURL:(nullable NSURL *)fileURL;
- (nullable UIImage *)capture;

@end
