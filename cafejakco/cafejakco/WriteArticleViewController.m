//
//  WriteArticleViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "WriteArticleViewController.h"
#import "HttpAdapter.h"

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

    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_write.png"] forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionBack:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)actionUpload:(id)sender {
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    NSDictionary *postDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"1", @"user_id",
                                 @"3", @"group_id",
                                 self.titleTextField.text, @"title",
                                 self.contentTextView.text, @"content",
                                 @"null", @"image",
                                 nil];
    
    if ([[httpAdapter SyncSendPostDataWithUrl:URL_JAKCO_SERVER_COMMUNITY_UPLOAD postData:postDataDic] isEqualToString:@"{\"status\": \"create success\"}"]) {
        NSLog(@"[WriteArticleViewController/actionUpload] upload success");
        [self actionBack:self];
    }
    else
        NSLog(@"[WriteArticleViewController/actionUpload] upload fail");
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"[WriteArticleViewController/handleTap] End editing");
    [self.view endEditing:YES];
}
@end
