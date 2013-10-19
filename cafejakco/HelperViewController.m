//
//  HelperViewController.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "HelperViewController.h"
#import "AppSession.h"

@interface HelperViewController ()

@end

@implementation HelperViewController

@synthesize nicknameTextField = _nicknameTextField;
@synthesize usernameTextField = _usernameTextField;

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
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if (iOSDeviceScreenSize.height == 480) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_helper_3.png"]]];
    }
    else if (iOSDeviceScreenSize.height == 568) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_helper_3-568h.png"]]];
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_helper.png"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.usernameTextField.text = [AppSession getUsername];
    self.nicknameTextField.text = [AppSession getNickname];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ActionLoginView:(id)sender {
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
@end
