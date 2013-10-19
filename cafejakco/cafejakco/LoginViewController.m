//
//  LoginViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 30..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpAdapter.h"
#import "AppSession.h"
#import "AppDBAdapter.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_login.png"] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[AppSession getIsLogin] isEqualToString:@"YES"])
    {
        [AppSession setUserId:@""];
        [AppSession setUsername:@""];
        [AppSession setNickname:@""];
        [AppSession setIsLogin:@"NO"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커] 헬퍼" message:@"로그아웃 되었습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"[LoginViewController/handleTap] End editing");
    [self.view endEditing:YES];
}

- (IBAction)actionBack:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)actionLogin:(id)sender {
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    NSDictionary *postDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.idTextField.text, @"username",
                                 self.pwTextField.text, @"password",
                                 nil];
    
    NSArray *responseArray = [httpAdapter SyncSendPostDataWithUrl:URL_JAKCO_SERVER_LOGIN postData:postDataDic];
    
    
    if (responseArray && ([responseArray count] > 0)) {
        NSDictionary *memberDict = [responseArray objectAtIndex:0];
        
        if ([[memberDict objectForKey:@"status"] isEqualToString:@"fail"]) {
            NSLog(@"[LoginViewController/actionLogin] login fail");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]로그인" message:@"올바른 이메일과 패스워드를 입력하세요." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            [alert show];
            return;
        }
        else
        {
            NSLog(@"[LoginViewController/actionLogin] login success : %@", memberDict);
            
            
            [AppSession setUserId:[NSString stringWithFormat:@"%@", [memberDict objectForKey:@"user_id"]]];
            [AppSession setUsername:[NSString stringWithFormat:@"%@", [memberDict objectForKey:@"user_name"]]];
            [AppSession setNickname:[NSString stringWithFormat:@"%@", [memberDict objectForKey:@"nickname"]]];
            [AppSession setIsLogin:@"YES"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]로그인" message:@"로그인을 성공하였습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            [alert show];
            [self actionBack:self];
            
        }
    }
    
}
@end
