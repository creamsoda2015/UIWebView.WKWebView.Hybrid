//
//  ViewController.m
//  HybridWebView
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 me. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mWebView = [WebViewManager createWebView:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) jsPanelController:self];
    // mWebView.customUA = "";
    mWebView.scalesPageToFit = YES;
    mWebView.backgroundColor = [UIColor blackColor];
    mWebView.webViewDelegate = self;
    mWebView.autoresizingMask = NO;
    [mWebView scrollBounceEnabled:NO];
    [mWebView scrollBarShow:NO];
    [mWebView removeGesture];
    [self.view addSubview:(UIView *)mWebView];
    
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.apple.com/jp/"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldStartLoad:(NSURL *)nsURL {
    return YES;
}

- (void)didStartLoad {
    
}

- (void)didFinishLoad {
    
}

- (void)didFailLoad:(NSError *)error {
    
}

@end
