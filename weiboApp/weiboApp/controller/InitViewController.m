//
//  InitViewController.m
//  weiboApp
//
//  Created by lanhu on 13-10-30.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "InitViewController.h"

@interface InitViewController ()

@end

@implementation InitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *urlString = @"https://api.weibo.com/oauth2/authorize?client_id=2909579077&redirect_uri=http://www.baidu.com&response_type=code&display=mobile&state=authorize";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [self.webView setDelegate:self];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *backURL = [request URL];
    NSString *backURLString = [backURL absoluteString];
    //判断是否是授权调用时返回的url
    if ([backURLString hasPrefix:@"http://www.baidu.com/?"]) {
        NSLog(@"back url string:%@", backURLString);
        
    }
    return YES;
}

@end
