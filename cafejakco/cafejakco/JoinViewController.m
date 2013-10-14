//
//  JoinViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "JoinViewController.h"
#import "HttpAdapter.h"

@interface JoinViewController ()

@end

@implementation JoinViewController

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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_register.png"] forBarMetrics:UIBarMetricsDefault];
    
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

- (IBAction)actionJoin:(id)sender {
    
    if ([self.pwTextField.text length] < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"비밀번호는 6자리 이상 입력하세요." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    else if (![self.pwTextField.text isEqualToString:self.pwCheckTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"비밀번호 확인이 맞지 않습니다." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    else if ([self.nicknameTextField.text length] > 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"별명은 최대 11자까지만 입력하세요." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    NSDictionary *postDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.idTextField.text, @"username",
                                 self.pwTextField.text, @"password",
                                 self.nicknameTextField.text, @"nickname",
                                 @"null", @"image",
                                 nil];
    
//    if ([[httpAdapter SyncSendPostDataWithUrl:URL_JAKCO_SERVER_MEMBERSHIP postData:postDataDic] isEqualToString:@"{\"status\": \"create success\"}"]) {
    if ([httpAdapter AsyncSendPostDataWithUrl:URL_JAKCO_SERVER_MEMBERSHIP postData:postDataDic]) {
        NSLog(@"[JoinViewController/actionUpload] upload success");
        
        [self actionBack:self];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"가입이 완료되었습니다." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
//        [alert show];
    }
    else
        NSLog(@"[JoinViewController/actionUpload] upload fail");
    
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"[JoinViewController/handleTap] End editing");
    [self.view endEditing:YES];
}
@end
