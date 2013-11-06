//
//  MainViewController.m
//  weiboApp
//
//  Created by lanhu on 13-11-5.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "MainViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"

#define FONT_SIZE 14.0f;
#define CELL_CONTENT_WIDTH 320.0f;
#define CELL_CONTENT_MARGIN 10.0f;

@interface MainViewController () {
    MBProgressHUD *hud;
}

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _statusArray = [[NSMutableArray alloc] init];
    _page = 1;
    _array = [[NSMutableArray alloc] init];
    
    [self addRefreshViewController];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_statusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -self Method

- (void) getWeiboData:(int) page {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        hud  = [[MBProgressHUD alloc] init];
        
        hud.dimBackground = YES;
        hud.labelText = @"正在加载数据...";
        [hud show:YES];
        [self.view addSubview:hud];
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSURL *url = [NSURL URLWithString:[InfoForSina returnFriendsTimeLintURLString:page]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSData *weiboData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *weiboString = [[NSString alloc] initWithData:weiboData encoding:NSUTF8StringEncoding];
            NSDictionary *weiboStatusDictionary = [weiboString  objectFromJSONString];
            if ([_array count] != 0) {
                [_array removeAllObjects];
            }
            [_array addObjectsFromArray:[weiboStatusDictionary objectForKey:@"statuses"]];
            for (NSDictionary *dictionary in _array) {
                Status *status = [[Status alloc] init];
                status = [status initWithJsonDictionary:dictionary];
                [_statusArray addObject:status];
            }
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [hud removeFromSuperview];
        });
    });
}

- (void) addRefreshViewController {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(RefreshViewControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void) RefreshViewControlEventValueChanged {
    [self.refreshControl beginRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中....."];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0f];
}

- (void) loadData {
    _statusArray = [[NSMutableArray alloc] init];
    _page = 1;
    [self getWeiboData:_page];
    if (self.refreshControl.refreshing == true) {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    }
}

- (void)refreshButton:(id)sender{
    _statusArray = [[NSMutableArray alloc] init];
    _page = 1;
    [self getWeiboData:_page];
}
    
#pragma mark - UIScrollViewDelegate
//当tableView滑动到底的情况
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffsetPoint = self.tableView.contentOffset;
    CGRect frame = self.tableView.frame;
    if (contentOffsetPoint.y == self.tableView.contentSize.height - frame.size.height) {
        [self getWeiboData:++_page];
    }
}







@end
