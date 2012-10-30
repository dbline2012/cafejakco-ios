//
//  WriteArticleViewController.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteArticleViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end
