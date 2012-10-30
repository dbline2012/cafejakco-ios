//
//  CommunityTableViewController.m
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 23..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "CommunityTableViewController.h"
#import "HttpAdapter.h"
#import "Article.h"
#import "CustomArticleCell.h"
#import "DetailArticleViewController.h"
#import "LoadingView.h"

@interface CommunityTableViewController ()

@end

@implementation CommunityTableViewController

@synthesize articles = _articles;

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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_story.png"] forBarMetrics:UIBarMetricsDefault];
    loadingView = [[LoadingView alloc] init];
    [self.view addSubview:loadingView];
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    dispatch_queue_t dQueue = dispatch_queue_create("com.apple.testQueue", NULL);
    dispatch_async(dQueue, ^{
        
        NSArray *tempArticles = [httpAdapter GetJsonDataWithUrl:@"http://kcoding.soseek.net/?pno=1"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            articles = [NSArray arrayWithArray:tempArticles];
            [self.tableView reloadData];
            [loadingView removeFromSuperview];
        });
    });
    page_num = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return articles.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ArticleTableCellIdentifier = @"ArticleTableCell";
    static NSString *MoreCellIdentifier = @"MoreCell";
    
    NSString *CellIdentifier = (indexPath.row == articles.count) ? MoreCellIdentifier : ArticleTableCellIdentifier;
    
    CustomArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CustomArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // TODO set the text
    if ([CellIdentifier isEqualToString:@"ArticleTableCell"])
    {
        Article *currentArticle = [articles objectAtIndex:indexPath.row];
        cell.usernameLabel.text = [currentArticle valueForKey:@"user_name"];
        cell.titleLabel.text = [currentArticle valueForKey:@"title"];
        cell.dateLabel.text = [currentArticle valueForKey:@"created"];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailArticleSeque"]) {
        detailArticleViewController = segue.destinationViewController;
        
        [detailArticleViewController setArticle:[articles objectAtIndex:self.tableView.indexPathForSelectedRow.row]];
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(articles.count == indexPath.row)
    {
        page_num++;
        loadingView = [[LoadingView alloc] init];
        [self.view addSubview:loadingView];
        HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
        dispatch_queue_t dQueue = dispatch_queue_create("com.apple.testQueue", NULL);
        dispatch_async(dQueue, ^{
            NSArray *tempArticles = [httpAdapter GetJsonDataWithUrl:[NSString stringWithFormat:@"http://kcoding.soseek.net/?pno=%d", page_num]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                //articles = [NSArray arrayWithArray:tempArticles];
                articles = [articles arrayByAddingObjectsFromArray:tempArticles];
                [self.tableView reloadData];
                [loadingView removeFromSuperview];
            });
        });
    }
}

@end
