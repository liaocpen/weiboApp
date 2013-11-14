//
//  Status.m
//  weiboApp
//
//  Created by lanhu on 13-11-5.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "Status.h"

@implementation Status

- (Status *)initWithJsonDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.statusId = [[dic objectForKey:@"id"] longLongValue];
        self.createdAt = [dic objectForKey:@"created_at"];
        self.text = [dic objectForKey:@"text"];
        
        //处理微博信息来源
        //ex:"source": "<a href="http://weibo.com" rel="nofollow">新浪微博</a>"
        
        
        NSString *src = [dic objectForKey:@"source"];
        NSRange r = [src rangeOfString:@"<a href"];
        NSRange end;
        //说明是以字符串“<a href”开头的
        if (r.location != NSNotFound) {
            NSRange start = [src rangeOfString:@"<a href=\""];
            if (start.location !=NSNotFound) {
                int l = [src length];
                NSRange fromRang = NSMakeRange(start.location + start.length, l - start.length - start.location);
                end = [src rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:fromRang];
                
                if (end.location != NSNotFound) {
                    r.location = start.location + start.length;
                    r.length = end.location - r.location;
                    self.sourceUrl = [src substringWithRange:r];
                }
                else {
                    self.sourceUrl = @"";
                }
            }
            else {
                self.sourceUrl = @"";
            }
            start = [src rangeOfString:@"\">"];
            end   = [src rangeOfString:@"</a>"];
            if (start.location != NSNotFound && end.location != NSNotFound) {
                r.location = start.location +start.length;
                r.length = end.location - r.location;
                self.source = [src substringWithRange:r];
            }
            else {
                self.source = @"";
            }
        }else {
            self.source =src;
        }
        self.favorited = (BOOL)[dic objectForKey:@"favorited"];
        //图像地址，小 中 大的url
        self.thumbnailPic = [dic objectForKey:@"thumbnail_pic"];
        self.bmiddlePic  = [dic objectForKey:@"bmiddle_pic"];
        self.originalPic = [dic objectForKey:@"original_pic"];
        
        self.commentsCount = [[dic objectForKey:@"comments_count"] integerValue];
        self.retweetsCount = [[dic objectForKey:@"reposts_count"] integerValue];
        
        //发微博人姓名信息
        NSDictionary* userDic = [dic objectForKey:@"user"];
        if (userDic) {
            self.screenName = [userDic objectForKey:@"screen_name"];
            self.userHeadImageURL = [userDic objectForKey:@"profile_image_url"];
            
        }
        
        NSDictionary* retweetedStatusDic = [dic objectForKey:@"retweeted_status"];
        
        if (retweetedStatusDic) {
            self.hasRetwitter = YES;
            self.retweetedStatus = [Status statusWithJsonDictionary:retweetedStatusDic];
            
            //有转发的博文
            if (self.retweetedStatus && ![self.retweetedStatus isEqual:[NSNull null]]) {
                NSString *url = self.retweetedStatus.thumbnailPic;
                self.haveRetwitterImage = (url != nil && [url length] != 0 ? YES : NO);//转发部分是否有图像
            }
        }else {
            //无转发
            self.hasRetwitter = NO;
            //无转发时 显示博文的image
            NSString *url = self.thumbnailPic;
            self.hasImage = (url != nil && [url length] != 0 ? YES : NO);
        }
    }
    return self;
}



+ (Status *)statusWithJsonDictionary:(NSDictionary *)dic{
    return [[Status alloc] initWithJsonDictionary:dic];
}

@end
