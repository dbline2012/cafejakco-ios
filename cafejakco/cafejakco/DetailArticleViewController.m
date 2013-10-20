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
        isExistPic = FALSE;
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_detail.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.titleLabel.text = [self.article valueForKey:@"title"];
    self.usernameLabel.text = [self.article valueForKey:@"user_name"];
    self.dateLabel.text = [[[[NSString stringWithFormat:[self.article
                                                         valueForKey:@"created"]] stringByReplacingOccurrencesOfString:@"-" withString:@"/"] componentsSeparatedByString:@" "] objectAtIndex:0];
    self.contentLabel.text = [self.article valueForKey:@"content"];
    
    if (![[self.article valueForKey:@"image"] isEqualToString:@"null"]) {
        isExistPic = TRUE;
    }
    
    dispatch_queue_t dQueue = dispatch_queue_create("com.apple.testQueue", NULL);
    dispatch_async(dQueue, ^{
        UIImage *image = NULL;
        @try {
            NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", URL_JAKCO_SERVER_IMAGE, [self.article valueForKey:@"image"]]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            image = [UIImage imageWithData:imageData];
        }
        @catch (NSException * e) {
            NSLog(@"Error: %@%@", [e name], [e reason]);
        }
        @finally {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.imageView.image = image;
            });
        }
    });

}

- (void)viewDidAppear:(BOOL)animated
{
    
}


- (IBAction)actionBack:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UITableViewController Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 65;
        case 1:
            if (isExistPic) {
                return 320;
            }
            return 0;
        case 2:
            return 100;
        default:
            return 44;
    }
    
    return 44;
}

@end
