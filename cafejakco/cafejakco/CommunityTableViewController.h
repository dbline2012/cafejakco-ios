//
//  CommunityTableViewController.h
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 23..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HttpAdapter;
@class DetailArticleViewController;
@class WriteArticleViewController;
@class LoadingView;

@interface CommunityTableViewController : UITableViewController
{
    NSArray *articles;
    DetailArticleViewController *detailArticleViewController;
    WriteArticleViewController *writeArticleViewController;
    LoadingView *loadingView;
    int page_num;
}

@property (nonatomic, strong) NSArray *articles;

@end
