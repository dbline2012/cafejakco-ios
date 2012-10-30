//
//  WriteArticleViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "WriteArticleViewController.h"

@interface WriteArticleViewController ()

@end

@implementation WriteArticleViewController

@synthesize titleTextField = _titleTextField;
@synthesize contentTextView = _contentTextView;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_write.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem.backBarButtonItem = [UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:191/255.0 green:20/255.0 blue:81/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
