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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.9];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [_hud setHidden:YES];
    [UIView commitAnimations];
    [_hud removeFromSuperview];
    [self performSegueWithIdentifier:@"MainSegue" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_hud removeFromSuperview];
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
        InfoForSina *infoForSina = [[InfoForSina alloc] init];
        [infoForSina getAccessToken:codeString];
        
        [self performSegueWithIdentifier:@"MainSegue" sender:nil];
    }
    return YES;
}

@end
