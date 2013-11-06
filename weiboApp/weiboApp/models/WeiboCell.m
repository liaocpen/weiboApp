//
//  WeiboCell.m
//  weiboApp
//
//  Created by Liao_Cpen on 13-11-5.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "WeiboCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation WeiboCell

#define FONT_SIZE 14.0f;
#define CELL_CONTENT_WIDTH 320.0f;
#define CELL_CONTENT_MARGIN 5.0f;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Custom Mehtod
- (void)setupCell:(Status *)status{
    //用block设置头像
    __block UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    
}
@end
