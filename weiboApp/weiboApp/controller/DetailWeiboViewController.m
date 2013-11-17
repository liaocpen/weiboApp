//
//  DetailWeiboViewController.m
//  weiboApp
//
//  Created by lanhu on 13-11-15.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "DetailWeiboViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface DetailWeiboViewController ()
{
    MBProgressHUD *_hud;
}

@end

@implementation DetailWeiboViewController

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
    _hud = [[MBProgressHUD alloc] init];
    _commentArray = [[NSMutableArray alloc] init];
    _page = 1;
    [self continueLoadData:_page];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Custom Method

- (void) continueLoadData:(int)page
{
    //gcd异步获取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
           _hud.labelText = @"正在加载评论数据...";
            [_hud show:YES];
            [self.view addSubview:_hud];
            
            NSString *urlString = [InfoForSina returnCommentUrlStringWithID:_status.statusId page:page];
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            NSData *commentListData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *dataListString = [[NSString alloc] initWithData:commentListData encoding:NSUTF8StringEncoding];
            NSDictionary *dataListDictionary = [dataListString  objectFromJSONString];
            _totalNum = [[dataListDictionary objectForKey:@"total_number"] integerValue];
            [_commentArray addObjectsFromArray:[dataListDictionary objectForKey:@"comments"]];
            
        });
        
        
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            [self.tableView reloadData];
            [_hud removeFromSuperview];
        });
    });
}

- (NSString *) getTimeString:(NSString *)string  {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [[inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
     [inputFormatter setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
     NSDate *inputDate = [inputFormatter dateFromString:string];
     
     NSDateFormatter *outFormatter = [[NSDateFormatter alloc] init];
     [outFormatter setLocale:[NSLocale currentLocale]];
     [outFormatter setDateFormat:@"HH:mm:ss"];
     NSString *str = [outFormatter stringFromDate:inputDate];
     return str;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //显示微博内容
    if (indexPath.row == 0) {
        WeiboCell *cell = [[WeiboCell alloc] init];
        [cell setupCell:_status];
        
        UIView *selectionView = [[UIView alloc] init];
        selectionView.backgroundColor = [UIColor whiteColor];
        [cell setSelectedBackgroundView:selectionView];
        
        return cell;
    }
    
    //评论
    else {
        static NSString *CellIdentifier = @"detailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (cell != nil) {
            [cell removeFromSuperview];
        }
        
        //评论数据
        //获取一个评论
        NSDictionary *dictionary = [_commentArray objectAtIndex:indexPath.row - 1];
        NSString *timeString = [dictionary objectForKey:@"created_at"];
        //评论时间
        NSString *commentString = [dictionary objectForKey:@"text"];
        //评论用户
        NSDictionary *user = [dictionary objectForKey:@"user"];
        //用户名
        NSString *userName = [user objectForKey:@"screen_name"];
        
        //发表评论用户的名称
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [userNameLabel setText:userName];
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        [userNameLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, 160, 30)];
        userNameLabel.tag = 100;
        [[cell viewWithTag:100] removeFromSuperview];
        [[cell contentView] addSubview:userNameLabel];
       
        //设置评论发布时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [timeLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        
        [timeLabel setText:[self getTimeString:timeString]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        timeLabel.adjustsFontSizeToFitWidth = YES;
        [timeLabel setFrame:CGRectMake(170, CELL_CONTENT_MARGIN, 140, 20)];
        timeLabel.tag = 101;
        [[cell viewWithTag:101] removeFromSuperview];
        [[cell contentView] addSubview:timeLabel];
        
        //评论内容
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
    }
}



@end
