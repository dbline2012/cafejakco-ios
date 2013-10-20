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
        isUpView = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
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

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [self performSelector:@selector(_addKeyboardNotification)];
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [self performSelector:@selector(_removeKeyboardNotification)];
    }
}

#pragma mark -
#pragma mark Keyboard Controller

- (void)keyboardWillAnimate:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    if([notification name] == UIKeyboardWillShowNotification && !isUpView)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - (keyboardBounds.size.height/3), self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"%f", keyboardBounds.size.height);
        isUpView = TRUE;
    }
    else if([notification name] == UIKeyboardWillHideNotification && isUpView)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (keyboardBounds.size.height/3), self.view.frame.size.width, self.view.frame.size.height)];
        isUpView = FALSE;
    }
    [UIView commitAnimations];
}

- (void)_addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAnimate:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAnimate:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)_removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
