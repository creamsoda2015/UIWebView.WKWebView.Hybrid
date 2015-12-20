//
//  ViewController.h
//  HybridWebView
//
//  Created by me on 2015/12/20.
//  Copyright © 2015年 me. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebViewManager.h"

@interface ViewController : UIViewController <WebViewDelegate> {
    id<WebViewProtocol> mWebView;
}

@end

