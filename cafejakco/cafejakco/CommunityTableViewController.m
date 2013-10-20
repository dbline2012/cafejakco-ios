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
#import "WriteArticleViewController.h"
#import "LoadingView.h"
#import "AppSession.h"

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
    
    page_num = 1;
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    dispatch_queue_t dQueue = dispatch_queue_create("com.apple.testQueue", NULL);
    dispatch_async(dQueue, ^{
        NSArray *tempNotices = [[NSArray alloc] init];
        @try {
            tempNotices = [httpAdapter GetJsonDataWithUrl:[NSString stringWithFormat:@"%@?pno=%d", URL_JAKCO_SERVER_COMMUNITY, page_num]];
        }
        @catch (NSException * e) {
            NSLog(@"Error: %@%@", [e name], [e reason]);
        }
        @finally {
            dispatch_sync(dispatch_get_main_queue(), ^{
                articles = [NSArray arrayWithArray:tempNotices];
                [self.tableView reloadData];
                [loadingView removeFromSuperview];
            });
        }
    });
    
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
        cell.dateLabel.text = [[[[NSString stringWithFormat:[currentArticle valueForKey:@"created"]] stringByReplacingOccurrencesOfString:@"-" withString:@"/"] componentsSeparatedByString:@" "] objectAtIndex:0];
        
        
        if (![[currentArticle valueForKey:@"image"] isEqualToString:@"null"]) {
            dispatch_queue_t dQueue = dispatch_queue_create("com.apple.testQueue", NULL);
            dispatch_async(dQueue, ^{
                UIImage *image = NULL;
                @try {
                    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", URL_JAKCO_SERVER_IMAGE, THUMBNAIL, [currentArticle valueForKey:@"image"]]];
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                    image = [UIImage imageWithData:imageData];
                }
                @catch (NSException * e) {
                    NSLog(@"Error: %@%@", [e name], [e reason]);
                }
                @finally {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        cell.imageView.image = image;
                    });
                }
            });
        }
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
            NSArray *tempNotices = [[NSArray alloc] init];
            @try {
                tempNotices = [httpAdapter GetJsonDataWithUrl:[NSString stringWithFormat:@"%@?pno=%d", URL_JAKCO_SERVER_COMMUNITY, page_num]];
            }
            @catch (NSException * e) {
                NSLog(@"Error: %@%@", [e name], [e reason]);
            }
            @finally {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    articles = [articles arrayByAddingObjectsFromArray:tempNotices];
                    [self.tableView reloadData];
                    [loadingView removeFromSuperview];
                });
            }
        });
    }
}

@end
