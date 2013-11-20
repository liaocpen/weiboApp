//
//  Users.m
//  weiboApp
//
//  Created by lanhu on 13-11-20.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "Users.h"

@implementation Users


- (void)initUserWithDictionary:(NSDictionary *)dic
{
    _IDString = [dic objectForKey:@"idstr"];
    _nameString = [[NSString alloc] initWithString:[dic objectForKey:@"name"]];
    _locationString = [dic objectForKey:@"location"];
    _descriptionString = [dic   objectForKey:@"description"];
    _profileImageURL = [[NSString alloc] initWithString:[dic objectForKey:@"profile_image_url"]];
    _gander = [dic  objectForKey:@"gender"];
    _followerCount = [[dic objectForKey:@"followers_count"] integerValue];
    _friendsCount = [[dic objectForKey:@"friends_count"] integerValue];
    _statusesCount = [[dic objectForKey:@"statuses_count"] integerValue];
    _favouritesCount = [[dic objectForKey:@"favourites_count"] integerValue];
    //注意：followMe 表示粉丝是否关注了我，这里是粉丝列表，当然是已经关注了我啦
    _followMe = ([dic objectForKey:@"follow_me"] == [NSNull null]) ? 0 : [[dic objectForKey:@"follow_me"] boolValue];
    //我是否关注了该粉丝
    _following = ([dic objectForKey:@"following"] == [NSNull null]) ? 0 : [[dic objectForKey:@"following"] boolValue];
    
    _onlineStatus = [[dic objectForKey:@"online_status"] integerValue];

}
@end
