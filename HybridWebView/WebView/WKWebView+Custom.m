//
//  WKWebView+Custom.m
//  WebViewSample
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 test. All rights reserved.
//

#import "WKWebView+Custom.h"

@implementation WKWebView (Custom)

@dynamic webViewDelegate;
@dynamic scalesPageToFit;
@dynamic currentURL;
@dynamic customUA;
@dynamic jsPanelController;

- (void)setWebViewDelegate:(id<WebViewDelegate>)webViewDelegate {
    objc_setAssociatedObject(self, @"webViewDelegate", webViewDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (id<WebViewDelegate>)webViewDelegate {
    return objc_getAssociatedObject(self, @"webViewDelegate");
}

- (void)setCustomUA:(NSString *)customUA {
    if([UIDevice currentDevice].systemVersion.floatValue >= 9.0f ) {
        self.customUserAgent = customUA;
    }
    objc_setAssociatedObject(self, @"customUA", customUA, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)customUA {
    return objc_getAssociatedObject(self, @"customUA");
}

- (void)setJsPanelController:(NSString *)jsPanelController {
    objc_setAssociatedObject(self, @"jsPanelController", jsPanelController, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)jsPanelController {
    return objc_getAssociatedObject(self, @"jsPanelController");
}

- (void)addDelegate {
    self.navigationDelegate = self;
    self.UIDelegate = self;
}

- (void)scrollBounceEnabled:(BOOL)enabled {
    self.scrollView.bounces = enabled;
}

- (void)scrollBarShow:(BOOL)isShow {
    self.scrollView.showsVerticalScrollIndicator = isShow;
}

- (void)removeGesture {
    [self recursiveGestureDelete:self];
}

- (void)recursiveGestureDelete:(UIView *)view {
    for(UIGestureRecognizer *gesture in [view gestureRecognizers]) {
        if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            // double tap scroll disabled
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
    
    NSURL *bundleURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]];

    // WKWebView can't load Bundle.
    if([baseURL.absoluteString hasPrefix:bundleURL.absoluteString]) {
        NSString *tmpDirPath = NSTemporaryDirectory();
        NSString *srcFile = [fileURL path];
        NSString *filename = [srcFile lastPathComponent];
        NSString *targetFile = [tmpDirPath stringByAppendingPathComponent:filename];
        NSFileManager* fileManager = [[NSFileManager alloc] init];
        if (![fileManager fileExistsAtPath:targetFile]) {
            if (![fileManager fileExistsAtPath:srcFile]) {
                return;
            }
            NSError * error = nil;
            if(![fileManager copyItemAtPath:srcFile toPath:targetFile error:&error]) {
                return;
            }
            error = nil;
        }
        
        fileURL = [NSURL fileURLWithPath:targetFile];
    }

    if ([self respondsToSelector:NSSelectorFromString(@"loadFileURL:allowingReadAccessToURL:")]) {
        [self loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    } else {
        [self loadRequest:[NSURLRequest requestWithURL:fileURL]];
    }
}

- (void)setScalesPageToFit:(BOOL)scalesPageToFit {
    
}

- (void)evaluateJSAsync:(NSString *)script completion:(void (^)(id result, NSError *error))completionHandler {
    [self evaluateJavaScript:script completionHandler:completionHandler];
}

- (NSURL *)currentURL {
    return self.URL;
}

- (nullable UIImage *)capture {
    CGSize size = self.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [self drawViewHierarchyInRect:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, size.width, size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    if(self.webViewDelegate != nil) {
        NSURL *url = navigationAction.request.URL;
        if (![self.webViewDelegate shouldStartLoad:url]) {
            policy = WKNavigationActionPolicyCancel;
        }
    }
    
    switch(navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
            break;
        case WKNavigationTypeFormSubmitted:
            break;
        case WKNavigationTypeBackForward:
            break;
        case WKNavigationTypeReload:
            break;
        case WKNavigationTypeFormResubmitted:
            break;
        case WKNavigationTypeOther:
            break;
    }
    
    decisionHandler(policy);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if(self.webViewDelegate != nil)
    {
        [self.webViewDelegate didStartLoad];
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %zd", error.code] message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self.jsPanelController presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if(self.webViewDelegate != nil)
    {
        [self.webViewDelegate didFinishLoad];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

    if(self.webViewDelegate != nil)
    {
        [self.webViewDelegate didFailLoad:error];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    
    NSString *hostName = webView.URL.host;
    
    // # other methods
    // NSURLAuthenticationMethodHTMLForm
    // NSURLAuthenticationMethodNegotiate
    // NSURLAuthenticationMethodNTLM
    // NSURLAuthenticationMethodClientCertificate
    
    NSURLProtectionSpace *challengeSpace = [challenge protectionSpace];
    NSString *authenticationMethod = [challengeSpace authenticationMethod];
    if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]
        || [authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPDigest]) {

        NSString *title = @"Authentication Required";
        NSString *message = [NSString stringWithFormat:@"This server %@ requires username and password.", hostName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"User name:";
            textField.secureTextEntry = YES;
        }];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Password:";
            textField.secureTextEntry = YES;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Log In" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *userName = ((UITextField *)alertController.textFields[0]).text;
            NSString *password = ((UITextField *)alertController.textFields[1]).text;
            
            // permanently stored credential setting.
            NSURLCredential *credential = [[NSURLCredential alloc] initWithUser:userName password:password persistence:NSURLCredentialPersistencePermanent];
            
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.jsPanelController presentViewController:alertController animated:YES completion:^{}];
        });
    } else if ([authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0) {
    
}

#pragma mark - WKUIDelegate

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    // for target="_blank" jump
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0) {
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
 
    NSString *hostString = webView.URL.host;
    NSString *sender = [NSString stringWithFormat:@"%@からの表示", hostString];
 
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:sender preferredStyle:UIAlertControllerStyleAlert];
 
    [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
 
    if(self.jsPanelController && [self.jsPanelController isKindOfClass:[UIViewController class]]) {
        [self.jsPanelController presentViewController:alertController animated:YES completion:^{}];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {

    NSString *hostString = webView.URL.host;
    NSString *sender = [NSString stringWithFormat:@"%@", hostString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:sender preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    
    if(self.jsPanelController && [self.jsPanelController isKindOfClass:[UIViewController class]]) {
        [self.jsPanelController presentViewController:alertController animated:YES completion:^{}];
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {

    NSString *hostString = webView.URL.host;
    NSString *sender = [NSString stringWithFormat:@"%@", hostString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:sender preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    
    if(self.jsPanelController && [self.jsPanelController isKindOfClass:[UIViewController class]]) {
        [self.jsPanelController presentViewController:alertController animated:YES completion:^{}];
    }
}

@end
