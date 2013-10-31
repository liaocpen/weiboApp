//
//  InitViewController.m
//  weiboApp
//
//  Created by lanhu on 13-10-30.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "InitViewController.h"
#import "MBProgressHUD.h"
@interface InitViewController ()
{
    NSTimer *_timer;
    MBProgressHUD *_hud;
}

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
    _hud = [[MBProgressHUD alloc] init];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] == nil) {
        _hud.labelText = @"正在加载授权页面.....";
        [_hud show:YES];
        [self.view addSubview:_hud];
        
        NSString *oauthUrlString = [InfoForSina returnOAuthUrlString];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:oauthUrlString]];
        [self.webView setDelegate:self];
        [_webView loadRequest:request];
        _imageView.hidden  = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goWebView) userInfo:nil repeats:NO];
        
    } else {
        _hud.labelText = @"正在加载微博内容....";
        [_hud show:YES];
        [self.view addSubview:_hud];
        _imageView.hidden = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goMainView) userInfo:nil repeats:NO];
    }
}


- (void) goWebView {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.9];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    _imageView.hidden = YES;
    [UIView commitAnimations];
}

- (void) goMainView {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *backURL = [request URL];  //接受重定向的URL
    NSString *backURLString = [backURL absoluteString];
    
    //判断是否是授权调用返回的url
    if ([backURLString hasPrefix:@"http://www.baidu.com/?"]) {
        
        //找到”code=“的range
        NSRange rangeOne;
        rangeOne=[backURLString rangeOfString:@"code="];
        
        //根据他“code=”的range确定code参数的值的range
        NSRange range = NSMakeRange(rangeOne.length+rangeOne.location, backURLString.length-(rangeOne.length+rangeOne.location));
        //获取code值
        NSString *codeString = [backURLString substringWithRange:range];
        //access token调用URL的string
        NSMutableString *muString = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/oauth2/access_token?client_id=579864993&client_secret=299ba743583e4f879f9b2c90b1409491&grant_type=authorization_code&redirect_uri=http://www.baidu.com&code="];
        [muString appendString:codeString];
        NSLog(@"access token url :%@",muString);
        
        //第一步，创建URL
        NSURL *urlstring = [NSURL URLWithString:muString];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = @"type=focus-c";//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        //如何从str1中获取到access_token
        NSDictionary *dictionary = [str1 objectFromJSONString];
        NSLog(@"access token is:%@",[dictionary objectForKey:@"access_token"]);
        
    }
    return YES;
}

@end
