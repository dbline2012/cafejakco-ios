//
//  HomeViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 28..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "HomeViewController.h"
#import "CustomNoticeCell.h"
#import "HttpAdapter.h"
#import "LoadingView.h"

@interface HomeViewController ()


@end

@implementation HomeViewController

@synthesize noticeTableView = _noticeTableView;
@synthesize notices = _notices;

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
    self.noticeTableView.dataSource = self;
    self.noticeTableView.delegate = self;
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home2.png"]]];
    }
    else if (iOSDeviceScreenSize.height == 568) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_home2-568h.png"]]];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_home.png"] forBarMetrics:UIBarMetricsDefault];
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(100.0, 180.0, 120.0, 80.0)];
    [self.view addSubview:loadingView];
    
    
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    dispatch_queue_t dQueue = dispatch_queue_create("com.apple.testQueue", NULL);
    dispatch_async(dQueue, ^{
        NSArray *tempNotices = [[NSArray alloc] init];
        @try {
            tempNotices = [httpAdapter GetJsonDataWithUrl:URL_JAKCO_SERVER_NOTICE];
        }
        @catch (NSException * e) {
            NSLog(@"Error: %@%@", [e name], [e reason]);
        }
        @finally {
            dispatch_sync(dispatch_get_main_queue(), ^{
                notices = [NSArray arrayWithArray:tempNotices];
                [self.noticeTableView reloadData];
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
    return notices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NoticeTableCell";
    id currentArticle = [notices objectAtIndex:indexPath.row];
    CustomNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CustomNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // TODO set the text
    cell.titleLabel.text = [currentArticle valueForKey:@"title"];
    cell.dateLabel.text = [[[[NSString stringWithFormat:[currentArticle valueForKey:@"created"]] stringByReplacingOccurrencesOfString:@"-" withString:@"/"] componentsSeparatedByString:@" "] objectAtIndex:0];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentArticle = [notices objectAtIndex:indexPath.row];
    NSString *alertString = [NSString stringWithFormat:@"제목 : %@\n\n%@", [currentArticle valueForKey:@"title"], [currentArticle valueForKey:@"content"]];
    alert = [[UIAlertView alloc] initWithTitle:@"[작커]공지사항" message:alertString delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    [alert show];
}

- (IBAction)actionGoWebHome:(id)sender {
    NSString *strUrl = URL_JAKCO_HOMEPAGE;
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)actionGoMap:(id)sender {
    NSString *strUrl = URL_JAKCO_MAP;
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    [[UIApplication sharedApplication] openURL:url];
}
@end
