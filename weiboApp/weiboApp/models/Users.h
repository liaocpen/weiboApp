//
//  Users.h
//  weiboApp
//
//  Created by lanhu on 13-11-20.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Users : NSObject

@property (nonatomic, strong) NSString *IDString; // 用户的UID： idstr

@property (nonatomic, strong) NSString *nameString;//用户的昵称： name

@property (nonatomic, strong) NSString *locationString;//所在地：location

@property (nonatomic, strong) NSString *descriptionString;//个人描述：description

@property (nonatomic, strong) NSString *profileImageURL;//头像地址

@property (nonatomic, strong) NSString *gander;//性别，m for 男， f for 女 ， n for 未知

@property (nonatomic) int followerCount;// 粉丝数

@property (nonatomic) int friendsCount;//关注数

@property (nonatomic) int statusesCount;//微博数

@property (nonatomic) int favouritesCount;//收藏数

@property (nonatomic) BOOL followMe;//时候关注当前登录用户

@property (nonatomic) BOOL following;//是否关注该粉丝

@property (nonatomic) int onlineStatus;//在线状态


- (void) initUserWithDictionary:(NSDictionary *)dic;



@end
