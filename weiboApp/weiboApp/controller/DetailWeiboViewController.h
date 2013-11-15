//
//  DetailWeiboViewController.h
//  weiboApp
//
//  Created by lanhu on 13-11-15.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "WeiboCell.h"
#import "InfoForSina.h"
#import "MBProgressHUD.h"


@interface DetailWeiboViewController : UITableViewController

@property (nonatomic, strong) Status *status;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic) NSInteger totalNum; //评论总数
@property (nonatomic) int page;
@end
