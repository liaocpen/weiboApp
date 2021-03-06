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
#import "WeiboCell.h"
#import "DetailWeiboViewController.h"



#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    //self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
//    self.automaticallyAdjustsScrollViewInsets = YES;

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
         self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _statusArray = [[NSMutableArray alloc] init];
    _page = 1;
    _array = [[NSMutableArray alloc] init];
    
    [self addRefreshViewController];
    [self getWeiboData:_page];
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
    static NSString *CellIdentifier = @"MainCell";
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Status *status = [self.statusArray objectAtIndex:[indexPath row]];
    if (cell == nil) {
        cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    [cell setupCell:status];
//    if (cell != nil) {
//        [cell removeFromSuperview];
//    }
//    cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    [cell setupCell:status];
    
    //设置被选中cell背景颜色
    UIView *selectionView = [[UIView alloc] init];
    selectionView.backgroundColor = [UIColor whiteColor];
    [cell setBackgroundView:selectionView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Status *status = [[Status alloc] init];
    Status *status = [self.statusArray objectAtIndex:[indexPath row]];
    
    //设置高度
    CGFloat yHeight = 70.0;
    
    //动态获取微博内容高度
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:status.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    yHeight += (size.height + CELL_CONTENT_MARGIN);
    
    //转发的情况
    Status *retwitterStatus = status.retweetedStatus;
    
    //有转发
    if (status.hasRetwitter && ![retwitterStatus isEqual:[NSNull null]])
    {
        //转发内容的文本内容
        NSString *retwitterContentText = [NSString stringWithFormat:@"%@:%@",retwitterStatus.screenName, retwitterStatus.text];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:retwitterContentText attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        yHeight += (size.height + CELL_CONTENT_MARGIN);
        
        //有转发图片
        if (status.haveRetwitterImage) {
            yHeight += (120 + CELL_CONTENT_MARGIN);
        }
    }
    //无转发
    else {
        if (status.hasImage) {
            yHeight += (120 + CELL_CONTENT_MARGIN);
        }
    }
    yHeight += 20;
    return yHeight;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _detailStatus = [[Status alloc] init];
    _detailStatus = [_statusArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        DetailWeiboViewController *detailVC = [segue destinationViewController];
        detailVC.status = _detailStatus;
    }
}


#pragma mark -self Method

- (void)refreshButton:(id)sender {
    _statusArray = [[NSMutableArray alloc] init];
   //重新获取数据
    _page = 1;
    [self getWeiboData:_page];
}

- (void) getWeiboData:(int) page {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        hud  = [[MBProgressHUD alloc] init];
        
       // hud.dimBackground = YES;
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

    
#pragma mark - UIScrollViewDelegate
//当tableView滑动到底的情况
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGPoint contentOffsetPoint = self.tableView.contentOffset;
//    CGRect frame = self.tableView.frame;
//    if (contentOffsetPoint.y == self.tableView.contentSize.height - frame.size.height) {
//        [self getWeiboData:++_page];
//    }
//    
//    
// 
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - self.tableView.frame.size.height) {
        [self getWeiboData:++_page];
    }
}


@end
