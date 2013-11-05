//
//  MainViewController.h
//  weiboApp
//
//  Created by lanhu on 13-11-5.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoForSina.h"
#import "Status.h"

@interface MainViewController : UITableViewController

//用来记录每一条微博信息
@property (nonatomic, strong) NSMutableArray *statusArray;

//传递的status
@property (nonatomic, strong) Status *detailStatus;

- (IBAction)refreshButton:(id)sender;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) int page;
@property (nonatomic, strong) NSMutableArray *array;



@end
