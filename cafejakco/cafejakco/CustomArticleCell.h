//
//  CustomArticleCell.h
//  cafejakco
//
//  Created by 강별 on 12. 10. 29..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomArticleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
