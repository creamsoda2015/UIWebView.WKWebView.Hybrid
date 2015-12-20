//
//  UIWebView+Custom.m
//  WebViewSample
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 test. All rights reserved.
//

#import "UIWebView+Custom.h"

@implementation UIWebView (Custom)

@dynamic webViewDelegate;
@dynamic currentURL;
@dynamic customUA;
@dynamic jsPanelController;

- (void)setWebViewDelegate:(id<WebViewDelegate>)webViewDelegate{
    objc_setAssociatedObject(self, @"webViewDelegate", webViewDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (id<WebViewDelegate>)webViewDelegate{
    return objc_getAssociatedObject(self, @"webViewDelegate");
}

- (void)setCustomUA:(NSString *)customUA{
    objc_setAssociatedObject(self, @"customUA", customUA, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)customUA{
    return objc_getAssociatedObject(self, @"customUA");
}

- (void)setJsPanelController:(NSString *)jsPanelController {
    objc_setAssociatedObject(self, @"jsPanelController", jsPanelController, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)jsPanelController {
    return objc_getAssociatedObject(self, @"jsPanelController");
}

- (void)addDelegate {
    self.delegate = self;
}

- (void)scrollBounceEnabled:(BOOL)enabled {
    for (id subview in self.subviews) {
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).bounces = enabled;
        }
    }
}

- (void)scrollBarShow:(BOOL)isShow {
    for (id subview in self.subviews) {
        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView *)subview).showsVerticalScrollIndicator = isShow;
        }
    }
}

- (void)removeGesture {
    [self recursiveGestureDelete:self];
}

- (void)recursiveGestureDelete:(UIView *)view {
    for(UIGestureRecognizer *gesture in [view gestureRecognizers]) {
        if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            // remove double tap gesture
            if(![(UITapGestureRecognizer *)gesture respondsToSelector:@selector(numberOfTapsRequired)]) {
                continue;
            }
            if([(UITapGestureRecognizer *)gesture numberOfTapsRequired] == 1) {
                continue;
            }
            [view removeGestureRecognizer:gesture];
        }
    }
    for (id subview in view.subviews) {
        [self recursiveGestureDelete:subview];
    }
}

- (void)loadLocalData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL fileURL:(NSURL *)fileURL {
    [self loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL]; 
}

- (void)evaluateJSAsync:(NSString *)script completion:(void (^)(id result, NSError *error))completionHandler {
    NSString *res = [self stringByEvaluatingJavaScriptFromString:script];
    if(completionHandler) {
        completionHandler(res, nil);
    }
}

- (NSURL *)currentURL {
    return [self.request URL];
}

- (nullable UIImage *)capture {
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(self.webViewDelegate != nil)
    {
        return [self.webViewDelegate shouldStartLoad:request.URL];
    }
    return NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if(self.webViewDelegate != nil)
    {
        [self.webViewDelegate didStartLoad];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if(self.webViewDelegate != nil)
    {
        [self.webViewDelegate didFinishLoad];
    }
}

- (void)webView:(UIWebView *)webView didFailLoad:(nullable NSError *)error {
    if(self.webViewDelegate != nil)
    {
        [self.webViewDelegate didFailLoad:error];
    }
}

@end
