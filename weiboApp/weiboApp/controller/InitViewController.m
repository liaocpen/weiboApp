//
//  InitViewController.m
//  weiboApp
//
//  Created by lanhu on 13-10-30.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "InitViewController.h"
#import "JSONKit.h"

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
    NSString *urlString = @"https://api.weibo.com/oauth2/authorize?client_id=579864993&redirect_uri=http://tiankong520.com/&response_type=code&display=mobile&state=authorize";
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
    if ([backURLString hasPrefix:@"http://tiankong520.com/?"]) {
        NSRange rangOne;
        rangOne = [backURLString rangeOfString:@"code="];
        NSRange range = NSMakeRange(rangOne.location + rangOne.length, backURLString.length - (rangOne.location + rangOne.length));
        NSString *codeString = [backURLString substringWithRange:range];
        NSMutableString *muString = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/oauth2/access_token?client_id=579864993&client_secret=89f430d4c927541c3e3924c0aec91c29&grant_type=authorization_code&redirect_uri=http://tiankong520.com&code="];
        [muString appendString:codeString];
        
        
        //创建URL
        NSURL *urlString = [NSURL URLWithString:muString];
        
        //创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlString cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str = @"type=focus-c";
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        //连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
        
        NSDictionary *dictionary = [str1 objectFromJSONSring];
        
        
        
    }
    return YES;
}

@end
