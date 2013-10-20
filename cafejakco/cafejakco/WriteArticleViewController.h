//
//  WriteArticleViewController.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteArticleViewController : UITableViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    BOOL isExistPic;
    BOOL isUpView;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UITableViewCell *imageViewCell;
- (IBAction)actionCamera:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionUpload:(id)sender;
@end
