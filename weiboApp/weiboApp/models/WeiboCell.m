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
    
}

- (UIImage *) getImageFromURL:(NSString *)fileURL{
    UIImage *resultImage = [[UIImage alloc] init];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    resultImage = [UIImage imageWithData:data];
    return resultImage;
}
@end
