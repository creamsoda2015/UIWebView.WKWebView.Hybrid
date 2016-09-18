//
//  ViewController.m
//  HybridWebView
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 me. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *urlText;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"container %f", self.containerView.frame.size.height);
    
    mWebView = [WebViewManager createWebView:CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height) jsPanelController:self];
    // mWebView.customUA = "";
    mWebView.scalesPageToFit = YES;
    mWebView.backgroundColor = [UIColor blackColor];
    mWebView.webViewDelegate = self;
    mWebView.autoresizingMask = NO;
    [mWebView scrollBounceEnabled:NO];
    [mWebView scrollBarShow:NO];
    [mWebView removeGesture];
    [self.containerView addSubview:(UIView *)mWebView];
    
    // if you use ssl connection, you need to set 'Exception Domains' in Info.plist.
    // check command : nscurl --ats-diagnostics --verbose {url}
    NSString *url = @"http://www.apple.com/jp/";
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self setUrlTextString:url];
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

- (void)setUrlTextString:(NSString *)urlString {
    self.urlText.text = urlString;
}

- (IBAction)loadButtonTouched:(id)sender {
    NSString *url = [self.urlText text];
    if ([url length] == 0)
    {
        return;
    }
    [mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

@end
