//
//  DetailArticleViewController.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;
@class CommunityTableViewController;

@interface DetailArticleViewController : UITableViewController
{
    UILabel *titleLabel;
    UILabel *usernameLabel;
    UILabel *dateLabel;
    UITextView *contentLabel;
    NSInteger pno;
    BOOL isExistPic;
}

- (IBAction)actionBack:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) Article *article;

@end
