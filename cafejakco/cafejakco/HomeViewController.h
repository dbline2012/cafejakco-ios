//
//  HomeViewController.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 28..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomNoticeCell;
@class LoadingView;

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *noticeTableView;
    NSArray *notices;
    UIAlertView *alert;
    LoadingView *loadingView;
}

- (IBAction)actionGoWebHome:(id)sender;
- (IBAction)actionGoMap:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *noticeTableView;
@property (strong, nonatomic) NSArray *notices;

@end
