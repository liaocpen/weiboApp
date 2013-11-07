//
//  WeiboCell.m
//  weiboApp
//
//  Created by Liao_Cpen on 13-11-5.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation WeiboCell

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 5.0f


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Custom Mehtod
- (void)setupCell:(Status *)status{
    //用block设置头像
    __block UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [headImageView setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, 50, 50)];
    
    CALayer *layer = [headImageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:0.6];
    
    __block UIImage *headImage = [[UIImage alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        headImage = [self getImageFromURL:status.userHeadImageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [headImageView setImage:headImage];
            [[self contentView] addSubview:headImageView];
        });
    });
    
    //发微博的用户名称
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [userNameLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [[self contentView] addSubview:userNameLabel];
    [userNameLabel setText:status.screenName];
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    [userNameLabel setFrame:CGRectMake(60, 10, 160, 28)];
    
    //评论与转发情况
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [commentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE - 1]];
    [[self contentView] addSubview:commentLabel];
    [commentLabel setText:[NSString stringWithFormat:@"评论:%d 转发:%d",status.commentsCount,status.retweetsCount]];
    commentLabel.adjustsFontSizeToFitWidth = YES;
    [commentLabel setTextAlignment:NSTextAlignmentRight];
    [commentLabel setFrame:CGRectMake(220, 13, 100, 28)];
    
    //低栏高度设置
    CGFloat yHeight = 0.0;
    
    //设置微博内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [contentLabel setNumberOfLines:0];
    [contentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [[self contentView] addSubview:contentLabel];
    
    //动态获取contentLabel高度
    //ios 7下 方法废弃了
//    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAXFLOAT);
//    CGSize size = [status.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontOfSize:FONT_SIZE]}];
    
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:status.text attributes:@{NSAttachmentAttributeName: contentLabel.font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    
    [contentLabel setText:status.text];
    [contentLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, headImageView.frame.origin.y + headImageView.frame.size.height + CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, size.height)];
    yHeight = contentLabel.frame.origin.y + contentLabel.frame.size.height;
    
    //转发状态
    Status *retwitterStatus = status.retweetedStatus;
    //有转发
    if (status.hasRetwitter && ![retwitterStatus isEqual:[NSNull null]]) {
        //转发内容的文本内容
        NSString *retwitterContentText = [NSString stringWithFormat:@"%@:%@",retwitterStatus.screenName,retwitterStatus.text];
        UILabel *retwitterContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [retwitterContentLabel setBackgroundColor:[UIColor grayColor]];
        [retwitterContentLabel  setLineBreakMode:NSLineBreakByWordWrapping];
        [retwitterContentLabel setNumberOfLines:0];
        [retwitterContentLabel  setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [[self contentView] addSubview:retwitterContentLabel];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:retwitterContentText attributes:@{NSAttachmentAttributeName: retwitterContentLabel.font}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        [retwitterContentLabel setText:retwitterContentText];
        [retwitterContentLabel setFrame:CGRectMake(6, contentLabel.frame.origin.y + contentLabel.frame.size.height, CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, size.height)];
        yHeight += retwitterContentLabel.frame.size.height;
        
        
        //转发的微博有头像
        if (status.haveRetwitterImage) {
            //设置转发的微博
            __block UIImageView *retwitterImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            __block UIImage *retwitterImage = [[UIImage alloc] init];
            
        }
    }
    
}

- (UIImage *) getImageFromURL:(NSString *)fileURL{
    UIImage *resultImage = [[UIImage alloc] init];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    resultImage = [UIImage imageWithData:data];
    return resultImage;
}
@end
