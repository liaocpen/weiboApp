//
//  Status.h
//  weiboApp
//
//  Created by lanhu on 13-11-5.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Status : NSObject


@property (nonatomic) long long            statusId;//微博ID
@property (nonatomic, strong) NSString*    createdAt;//微博创建时间
@property (nonatomic, strong) NSString*    text;//微博内容
@property (nonatomic, strong) NSString*    source;//微博来源
@property (nonatomic, strong) NSString*    sourceUrl;//微博来源url
@property (nonatomic, assign) BOOL         favorited;//是否已经收藏
@property (nonatomic, strong) NSString*    thumbnailPic;//缩略图
@property (nonatomic, strong) NSString*    bmiddlePic;//中型图片
@property (nonatomic, strong) NSString*    originalPic;//原始图片
@property (nonatomic, strong) NSString*    screenName;//作者姓名
@property (nonatomic, strong) NSString*    userHeadImageURL;//作者头像

@property (nonatomic, assign) int          commentsCount;//评论数
@property (nonatomic, assign) int          retweetsCount;//转发数
@property (nonatomic, retain) Status*      retweetedStatus;//转发的博文

@property (nonatomic, assign) BOOL          hasRetwitter;
@property (nonatomic, assign) BOOL          haveRetwitterImage;
@property (nonatomic, assign) BOOL          hasImage;

- (Status *)initWithJsonDictionary:(NSDictionary *)dic;
+ (Status *)statusWithJsonDictionary:(NSDictionary *)dic;
@end
