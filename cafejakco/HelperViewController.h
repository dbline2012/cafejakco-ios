//
//  HelperViewController.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelperViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;

- (IBAction)ActionLoginView:(id)sender;

@end
