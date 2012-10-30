//
//  AddTaskViewController.m
//  cafejakco
//
//  Created by Byeol Kang on 12. 10. 22..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "AddTaskViewController.h"
#import "TaskListViewController.h"
#import "Task.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

@synthesize nameField = _nameField;
@synthesize task = _task;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (void)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonPressed:(id)sender {
    Task *newTask = [[Task alloc] initWithName:self.nameField.text done:NO];
    [self.task.tasks addObject:newTask];
    [self dismissModalViewControllerAnimated:YES];
    [self.task.tableView reloadData];
}

@end
