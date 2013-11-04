//
//  InfoForSina.m
//  weiboApp
//
//  Created by lanhu on 13-10-31.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "InfoForSina.h"

@implementation InfoForSina


+ (NSString *) returnAccessTokenString {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
}

+ (NSString *) returnOAuthUrlString {
    return [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&state=authorize",OAuth_URL,APP_KEY,APP_REDIRECT_URL];
}

- (void) getAccessToken:(NSString *)code{
    //access token调用url的string
    NSMutableString *accessTokenUrlString = [[NSMutableString alloc] initWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=",ACCESS_TOKEN_URL,APP_KEY,APP_SECRET,APP_REDIRECT_URL];
    [accessTokenUrlString appendString:code];
    //同步post请求
    NSURL *urlString = [NSURL URLWithString:accessTokenUrlString];
    //创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlString cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //链接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *backString = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [backString objectFromJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"access_token"] forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self getUIDString];
    
    
}

- (void) getUIDString {
    NSString *uidIRLString = [[NSString alloc] initWithFormat:@"%@?access_token=%@",GET_UID_URL, [InfoForSina returnAccessTokenString]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:uidIRLString]];
    NSError *error;
    NSData *uidData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *uidString = [[NSString alloc] initWithData:uidData encoding:NSUTF8StringEncoding];
    NSDictionary *uidDictionary = [uidString objectFromJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:[uidDictionary objectForKey:@"uid"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (NSString *) returnFollowersUrlStringWithCursor:(int)cursor {
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    return  [NSString stringWithFormat:@"%@?access_token=%@&uid=%lld&cursor=%d",FOLLOWERS_URL, [InfoForSina returnAccessTokenString], [uidString longLongValue], cursor];
}

+ (NSString *) returnFriendsTimeLintURLString:(int)page {
    return [NSString stringWithFormat:@"%@?access_token=%@&page=%d",
            FRIENDSHIPS_TIMELINE, [InfoForSina returnAccessTokenString], page];
}

+ (NSString *) returnUserTimeLineURLString {
    NSString *uidString = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    return [NSString stringWithFormat:@"%@?access_token=%@&id=%@",
            USERS_TIMELINE, [InfoForSina returnAccessTokenString], uidString];
}

+ (NSString *) returnCommentUrlStringWithID:(long long)weiboID page:(int)page {
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@?access_token=%@&id=%lld&page=%d", COMMENTS, [InfoForSina returnAccessTokenString], weiboID, page];
    return urlString;
}







@end
