//
//  DeckViewController.m
//  weiboApp
//
//  Created by lanhu on 13-11-4.
//  Copyright (c) 2013年 Liao_Cpen. All rights reserved.
//

#import "DeckViewController.h"

@interface DeckViewController ()

@property (nonatomic, strong) MainViewController *centerController;

@end

@implementation DeckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _centerController = (MainViewController *)[sb instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    [self.view addSubview:_centerController.view];
    [_centerController.view setTag:1];
    [_centerController.view setFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
