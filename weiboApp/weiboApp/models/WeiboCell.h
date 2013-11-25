//
//  WeiboCell.h
//  weiboApp
//
//  Created by Liao_Cpen on 13-11-5.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"

@interface WeiboCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;

- (void) setupCell: (Status *)status;


@end
