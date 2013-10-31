//
//  InfoForSina.h
//  weiboApp
//
//  Created by lanhu on 13-10-31.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

#define APP_KEY                                 @"579864993"
#define APP_SECRET                              @"299ba743583e4f879f9b2c90b1409491"
#define APP_REDIRECT_URL                        @"http://www.baidu.com"
#define OAuth_URL                               @"https://api.weibo.com/oauth2/authorize"
#define ACCESS_TOKEN_URL                        @"https://api.weibo.com/oauth2/access_token"
#define GET_UID_URL                             @"https://api.weibo.com/2/account/get_uid.json"
#define FOLLOWERS_URL                           @"https://api.weibo.com/2/friendships/followers.json"
#define FRIENDSHIPS_CREAT                       @"https://api.weibo.com/2/friendships/create.json"
#define FRIENDSHIPS_DESTORY                     @"https://api.weibo.com/2/friendships/destroy.json"
#define FRIENDSHIPS_TIMELINE                    @"https://api.weibo.com/2/statuses/friends_timeline.json"
#define USERS_TIMELINE                          @"https://api.weibo.com/2/statuses/user_timeline.json"
#define WEIBO_UPDATE                            @"https://api.weibo.com/2/statuses/update.json"
#define WEIBO_UPLOAD                            @"https://api.weibo.com/2/statuses/upload.json"
#define COMMENTS                                @"https://api.weibo.com/2/comments/show.json"

@interface InfoForSina : NSObject
//返回access token
+ (NSString *) returnAccessTokenString;
//返回获取access token 的url
+ (NSString *) returnOAuthUrlString;
//获取access token的方法
- (void) getAccessToken: (NSString *) code;
// 返回获取粉丝列表的URL
+ (NSString *) returnFollowersUrlStringWithCursor: (int)cursor;

//加载关注好友微博数据的URL
+ (NSString *) returnFriendsTimeLintURLString: (int)page;
//返回获取用户自身微博数据的url
+ (NSString *) returnUserTimeLineURLString;
//返回评论url
+ (NSString *) returnCommentUrlStringWithID: (long long)weiboID page:(int)page;

@end
