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
    hud.labelText = @"loading....";
    [hud show:YES];
    [coverView addSubview:hud];
    
    __block UIImage *image;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrlString]]];
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            [hud removeFromSuperview];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.tag = kImageViewTag;
            CGRect rect = [self convertRect:self.bounds toView:self.window];
            imageView.frame = rect;
            
            
            [coverView addSubview:imageView];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:KAnimationDuration];
            imageView.frame = [self autoFitFrame];
            
            if (imageView.frame.size.height > self.window.frame.size.height) {
                [imageView setFrame:CGRectMake(coverView.frame.size.width / 2 - kImageViewWidth / 2, 20, kImageViewWidth, imageView.frame.size.height)];
                
                //添加拖动手势
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
                [panGesture setMaximumNumberOfTouches:1];
                [panGesture setMinimumNumberOfTouches:1];
                [coverView addGestureRecognizer:panGesture];
                
            }
            [UIView commitAnimations];
        });
    });
    
    
    
}

//处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecongnizer{
    
    UIImageView *view = (UIImageView *)[[self window] viewWithTag:kImageViewTag];
    if (panGestureRecongnizer.state == UIGestureRecognizerStateBegan || panGestureRecongnizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecongnizer translationInView: view.superview];
        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + translation.y, view.frame.size.width, view.frame.size.height)];
        [panGestureRecongnizer setTranslation:CGPointZero inView:view.superview];
    }
    
}

//自动按原UIImageView等比例调整目标的rect
- (CGRect)autoFitFrame {
    //固定宽 高 等比例动态变化
    float width = kImageViewWidth;
    float targetHeight = (width * self.frame.size.height) / self.frame.size.width;
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    CGRect targetRect = CGRectMake(coverView.frame.size.width / 2 - width / 2, coverView.frame.size.height / 2 - targetHeight /2, width, targetHeight);
    return targetRect;
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
