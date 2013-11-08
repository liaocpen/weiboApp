//
//  UIImageView+UImageViewEx.m
//  weiboApp
//
//  Created by lanhu on 13-11-8.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#define kCoverViewTag       2334
#define kImageViewTag       2335
#define KAnimationDuration  0.3f
#define kImageViewWidth     300.0f
#define kBackViewColor      [UIColor colorWithWhite:0.667 alpha:0.5f]


#import "UIImageView+UImageViewEx.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>



static const void *myKey = (void *)@"myKey";


@implementation UIImageView (UImageViewEx)


#pragma mark - Custom Method
//set Method
- (void) setImageUrlString:(NSString *)url
{
    objc_setAssociatedObject(self, myKey, url, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//get Method
- (NSString *)imageUrlString {
    return objc_getAssociatedObject(self, myKey);
}

//添加单击手势处理---放大图片
- (void)addDetailShow
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)imageTap {
    UIView *coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    coverView.backgroundColor = kBackViewColor;
    coverView.tag = kCoverViewTag;
    UITapGestureRecognizer *hiddenViewGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenViewAnimation)];
    [coverView addGestureRecognizer:hiddenViewGecognizer];
    
    
    [[self window] addSubview:coverView];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.dimBackground = YES;
    
    
    
}

- (void)hiddenViewAnimation {
    UIImageView *imageView = (UIImageView *)[[self window] viewWithTag:kImageViewTag];
    [UIView beginAnimations:nil context:nil];
    //动画时长
    [UIView setAnimationDuration:KAnimationDuration];
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    [UIView commitAnimations];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:KAnimationDuration];
}

- (void)hiddenView {
    UIView *coverView = (UIView *)[[self window]viewWithTag:kCoverViewTag];
    [coverView removeFromSuperview];
}










@end
