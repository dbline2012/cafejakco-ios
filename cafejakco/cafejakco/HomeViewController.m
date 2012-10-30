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
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg6.png"]]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_home.png"] forBarMetrics:UIBarMetricsDefault];
    
    loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(100.0, 180.0, 120.0, 80.0)];
    [self.view addSubview:loadingView];
    
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    dispatch_queue_t dQueue = dispatch_queue_create("com.apple.testQueue", NULL);
    dispatch_async(dQueue, ^{
        NSArray *tempNotices = [httpAdapter GetJsonDataWithUrl:@"http://kcoding.soseek.net/notice/?pno=1"];
        dispatch_sync(dispatch_get_main_queue(), ^{
            notices = [NSArray arrayWithArray:tempNotices];
            [self.noticeTableView reloadData];
            [loadingView removeFromSuperview];
        });
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
    cell.dateLabel.text = [currentArticle valueForKey:@"created"];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    id currentArticle = [notices objectAtIndex:indexPath.row];
    NSString *alertString = [NSString stringWithFormat:@"제목 : %@\n\n%@", [currentArticle valueForKey:@"title"], [currentArticle valueForKey:@"content"]];
    alert = [[UIAlertView alloc] initWithTitle:@"[작커]공지사항" message:alertString delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
    [alert show];
}

@end
