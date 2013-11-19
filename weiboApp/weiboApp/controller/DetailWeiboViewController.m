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
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
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
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
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
    return 1 + [_commentArray count];
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
        //评论内容
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
        [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [commentLabel setNumberOfLines:0];
        [commentLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        
        NSAttributedString *attributeText = [[NSAttributedString alloc] initWithString:commentString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect rect = [attributeText boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        [commentLabel setText:commentString];
        [commentLabel setFrame:CGRectMake(CELL_CONTENT_MARGIN, 30 + CELL_CONTENT_MARGIN * 2, (CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2), size.height)];
        commentLabel.tag = 102;
        [[cell viewWithTag:102] removeFromSuperview];
        [[cell contentView] addSubview:commentLabel];
        
        //选择时背景
        UIView *selectionView = [[UIView alloc] init];
        selectionView.backgroundColor = [UIColor whiteColor];
        [cell setSelectedBackgroundView:selectionView];
        
        
        return cell;
        
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //高度设置
        CGFloat yHeight = 70.0;
        //微博内容高度
        NSAttributedString *attringText = [[NSAttributedString alloc] initWithString:_status.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect rect = [attringText boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGSize size = rect.size;
        yHeight += (size.height + CELL_CONTENT_MARGIN);
        
        //转发情况
        Status *retwitterStatus = _status.retweetedStatus;
        //有转发
        if (_status.hasRetwitter && ![retwitterStatus isEqual:[NSNull null]]) {
            //转发内容的文本内容
            NSString *retwitterContentText = [NSString stringWithFormat:@"%@:%@", retwitterStatus.screenName, retwitterStatus.text];
            NSAttributedString *attributerText = [[NSAttributedString alloc] initWithString:retwitterContentText attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}];
            CGRect rect = [attributerText boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            yHeight += (rect.size.height + CELL_CONTENT_MARGIN);
            
            //转发有图像
            if (_status.haveRetwitterImage) {
                yHeight += (120 + CELL_CONTENT_MARGIN);
                
            }
            
        }
        //无转发
        else{
            //微博有图像
            if (_status.hasImage) {
                yHeight += (120 + CELL_CONTENT_MARGIN);
            }
        }
        yHeight += 20;
        return yHeight;
    }
    else {
        //获取一个评论
        NSDictionary *dictionary = [_commentArray objectAtIndex:indexPath.row - 1];
        
        NSString *commentString = [dictionary objectForKey:@"text"];
        NSAttributedString *attriubuedText = [[NSAttributedString alloc] initWithString:commentString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FONT_SIZE]}];
        CGRect rect = [attriubuedText   boundingRectWithSize:(CGSize){CELL_CONTENT_WIDTH - CELL_CONTENT_MARGIN * 2, MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return  (30 + 3 * CELL_CONTENT_MARGIN + rect.size.height);
    }
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.tableView.contentOffset.y > self.tableView.contentSize.height - self.tableView.frame.size.height) {
        if (_totalNum <= 50 || _page > (_totalNum / 50 + 1)) {
            MBProgressHUD *endHud = [[MBProgressHUD alloc] init];
            endHud.mode = MBProgressHUDModeText;
            endHud.labelText = @"提示";
            endHud.detailsLabelText = @"scroll to the end";
            [self.tableView addSubview:endHud];
            [endHud show:YES];
            [endHud hide:YES afterDelay:1];
            
        }
        else if (_totalNum > [_commentArray count]){
            [self continueLoadData:++_page];
        }
    }
}

@end
