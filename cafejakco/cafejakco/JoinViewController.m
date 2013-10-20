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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_register.png"] forBarMetrics:UIBarMetricsDefault];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"비밀번호는 6자리 이상 입력하세요." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    else if (![self.pwTextField.text isEqualToString:self.pwCheckTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"비밀번호 확인이 맞지 않습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    else if ([self.nicknameTextField.text length] > 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"별명은 최대 11자까지만 입력하세요." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        return;
    }
    
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    NSDictionary *postDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.idTextField.text, @"username",
                                 self.pwTextField.text, @"password",
                                 self.nicknameTextField.text, @"nickname",
                                 @"1", @"group_id",
                                 @"null", @"sex",
                                 @"null", @"image",
                                 nil];
    
    if ([httpAdapter AsyncSendPostDataWithUrl:URL_JAKCO_SERVER_MEMBERSHIP postData:postDataDic]) {
        NSLog(@"[JoinViewController/actionUpload] upload success");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]회원가입" message:@"가입이 완료되었습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
        [alert show];
        [self actionBack:self];

    }
    else
        NSLog(@"[JoinViewController/actionUpload] upload fail");
    
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"[JoinViewController/handleTap] End editing");
    [self.view endEditing:YES];
    [self performSelector:@selector(_removeKeyboardNotification)];
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
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - (keyboardBounds.size.height/2 + 15), self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"%f", keyboardBounds.size.height);
        isUpView = TRUE;
    }
    else if([notification name] == UIKeyboardWillHideNotification && isUpView)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (keyboardBounds.size.height/2 + 15), self.view.frame.size.width, self.view.frame.size.height)];
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
