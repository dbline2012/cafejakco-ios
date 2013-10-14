//
//  DetailArticleViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "DetailArticleViewController.h"
#import "Article.h"
#import "CommunityTableViewController.h"

@interface DetailArticleViewController ()

@end

@implementation DetailArticleViewController

@synthesize titleLabel = _titleLabel;
@synthesize usernameLabel = _usernameLabel;
@synthesize dateLabel = _dateLabel;
@synthesize contentLabel = _contentLabel;

@synthesize article = _article;

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_detail.png"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    self.titleLabel.text = [self.article valueForKey:@"title"];
    self.usernameLabel.text = [self.article valueForKey:@"user_name"];
    self.dateLabel.text = [[[[NSString stringWithFormat:[self.article
                                                         valueForKey:@"created"]] stringByReplacingOccurrencesOfString:@"-" withString:@"/"] componentsSeparatedByString:@" "] objectAtIndex:0];
    self.contentLabel.text = [self.article valueForKey:@"content"];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
}


- (IBAction)actionBack:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
