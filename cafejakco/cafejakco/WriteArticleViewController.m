//
//  WriteArticleViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "WriteArticleViewController.h"
#import "HttpAdapter.h"
#import "AppSession.h"

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

- (void)viewDidAppear:(BOOL)animated
{
    if ([[AppSession getIsLogin] isEqualToString:@"NO"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커] 글쓰기" message:@"로그인 하셔야 글을 작성할 수 있습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        
        [self actionBack:self];
        
    }
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
                                 [AppSession getUserId], @"user_id",
                                 @"3", @"group_id",
                                 self.titleTextField.text, @"title",
                                 self.contentTextView.text, @"content",
                                 @"null", @"image",
                                 nil];
    
    NSArray *responseArray = [httpAdapter SyncSendPostDataWithUrl:URL_JAKCO_SERVER_COMMUNITY_UPLOAD postData:postDataDic];

    if (responseArray && ([responseArray count] > 0)) {
        NSDictionary *resultDict = [responseArray objectAtIndex:0];
        
        if ([[resultDict objectForKey:@"status"] isEqualToString:@"fail"]) {
            NSLog(@"[WriteArticleViewController/actionUpload] upload fail");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]글쓰기" message:@"글쓰기를 실패하였습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            [alert show];
            return;
        }
        else if([[resultDict objectForKey:@"status"] isEqualToString:@"success"])
        {
            NSLog(@"[WriteArticleViewController/actionUpload] upload success");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]글쓰기" message:@"글쓰기를 성공하였습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            [alert show];
            
            [self actionBack:self];
            
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"[WriteArticleViewController/handleTap] End editing");
    [self.view endEditing:YES];
}
@end
