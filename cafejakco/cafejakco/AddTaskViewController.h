//
//  AddTaskViewController.h
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 22..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskListViewController;

@interface AddTaskViewController : UITableViewController

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField *nameField;

@property (nonatomic, strong) TaskListViewController *task;

@end
