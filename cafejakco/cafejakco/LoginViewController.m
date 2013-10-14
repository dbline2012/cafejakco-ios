//
//  LoginViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 30..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpAdapter.h"


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
    
    if ([[httpAdapter SyncSendPostDataWithUrl:@"http://localhost:8000/login/" postData:postDataDic] isEqualToString:@"{\"status\": \"login success\"}"]) {
        NSLog(@"[LoginViewController/actionLogin] login success");
        [self actionBack:self];
    }
    else
        NSLog(@"[LoginViewController/actionLogin] login fail");
}
@end
