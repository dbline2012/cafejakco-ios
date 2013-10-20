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
@synthesize imageView = _imageView;
@synthesize imageViewCell = _imageViewCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        isExistPic = FALSE;
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_write.png"] forBarMetrics:UIBarMetricsDefault];
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

- (IBAction)actionCamera:(id)sender {
    NSLog(@"camera");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진 촬영", @"앨범에서 가져오기", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)actionBack:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)actionUpload:(id)sender {
    HttpAdapter *httpAdapter = [[HttpAdapter alloc] init];
    
    NSString *filename = @"null";
    if (isExistPic) {
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 70);
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd_MM_YY_HH_mm_ss"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        filename = [NSString stringWithFormat:@"%@_%@.jpg", [AppSession getUserId], dateString];
        
        NSArray *fileResponseArray = [httpAdapter SyncSendPostImageDataWithUrl:URL_JAKCO_SERVER_UPLOAD file:imageData filename:filename];
        if (fileResponseArray && ([fileResponseArray count] > 0))
        {
            NSDictionary *resultDict = [fileResponseArray objectAtIndex:0];
            if ([[resultDict objectForKey:@"status"] isEqualToString:@"fail"])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]업로드" message:@"이미지 업로드를 실패하였습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"[작커]업로드" message:@"이미지 업로드를 성공하였습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
                [alert show];
            }
        }
    }
    
    NSDictionary *postDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [AppSession getUserId], @"user_id",
                                 @"1", @"group_id",
                                 self.titleTextField.text, @"title",
                                 self.contentTextView.text, @"content",
                                 filename, @"image",
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

#pragma mark -
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    [imagePickerController setAllowsEditing:YES];
    
    if (buttonIndex == 0) {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentModalViewController:imagePickerController animated:YES];
    }
    else if (buttonIndex == 1) {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

#pragma mark -
#pragma mark UIImagePikerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSLog(@"[WriteArticleViewController/didFinishPickingImage] image 화면에 불러오기 완료");
    NSLog(@"[WriteArticleViewController/didFinishPickingImage] imageview size : w - %f, h - %f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    NSLog(@"[WriteArticleViewController/didFinishPickingImage] image size : w - %f, h - %f", image.size.width, image.size.height);
    
    isExistPic = TRUE;
    [self.tableView reloadData];
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.size = CGSizeMake(300, 300);
    self.imageView.frame = imageFrame;
    self.imageView.image = image;
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableViewController Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44;
        case 1:
            if (isExistPic) {
                return 320;
            }
            return 0;
        case 2:
            return 80;
        default:
            return 44;
    }
    
    return 44;
}

#pragma mark -
#pragma mark UITextView Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self performSelector:@selector(_addKeyboardNotification)];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self performSelector:@selector(_removeKeyboardNotification)];
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
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - (keyboardBounds.size.height/2 + 20), self.view.frame.size.width, self.view.frame.size.height)];
        isUpView = TRUE;
    }
    else if([notification name] == UIKeyboardWillHideNotification && isUpView)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (keyboardBounds.size.height/2 + 20), self.view.frame.size.width, self.view.frame.size.height)];
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
