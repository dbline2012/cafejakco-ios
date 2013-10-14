//
//  JoinViewController.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *idTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwTextField;
@property (strong, nonatomic) IBOutlet UITextField *pwCheckTextField;
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionJoin:(id)sender;
	
@end
