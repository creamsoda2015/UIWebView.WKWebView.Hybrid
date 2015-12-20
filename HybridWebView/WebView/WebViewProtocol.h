//
//  WebViewProtocol.h
//  WebViewSample
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@protocol WebViewDelegate
- (BOOL)shouldStartLoad:(nullable NSURL*)nsURL;
- (void)didStartLoad;
- (void)didFinishLoad;
- (void)didFailLoad:(nullable NSError*)error;
@end

@protocol WebViewProtocol <NSObject>

@required
@property (nonatomic, nullable) id<WebViewDelegate> webViewDelegate;

@property(nonatomic) CGRect frame;
@property(nonatomic) CGRect bounds;

@property (nonatomic, readonly) BOOL canGoBack;
@property (nonatomic, readonly) BOOL canGoForward;
@property (nonatomic, readonly) BOOL loading;

@property (nonatomic) BOOL scalesPageToFit;
@property (nullable, nonatomic,copy) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) UIViewAutoresizing autoresizingMask;

@property(nonatomic, nullable) NSURL *currentURL;

@property(nonatomic, nullable) NSString *customUA;
@property(nonatomic, nullable) UIViewController *jsPanelController;

- (void)addDelegate;
- (void)scrollBounceEnabled:(BOOL)enabled;
- (void)scrollBarShow:(BOOL)isShow;
- (void)removeGesture;
- (void)loadRequest:(nullable NSURLRequest *)request;

- (void)reload;
- (void)stopLoading;

- (void)goBack;
- (void)goForward;

- (void)evaluateJSAsync:(nullable NSString *)script completion:(nullable void (^)(id __nullable result, NSError* _Nullable error))completionHandler;

- (void)loadLocalData:(nullable NSData *)data MIMEType:(nullable NSString *)MIMEType textEncodingName:(nullable NSString *)textEncodingName baseURL:(nullable NSURL *)baseURL fileURL:(nullable NSURL *)fileURL;
- (nullable UIImage *)capture;

@optional

@end
