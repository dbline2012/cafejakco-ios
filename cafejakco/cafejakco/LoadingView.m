//
//  LoadingView.m
//  cafejakco
//
//  Created by 강별 on 12. 10. 30..
//  Copyright (c) 2012년 doubleline. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setFrame:CGRectMake(100.0, 120.0, 120.0, 80.0)];
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
        
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(45.0, 15.0, 30.0, 30.0)];
        [self addSubview:indicator];
        [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [indicator startAnimating];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 47.0,  90.0, 30.0)];
        [textLabel setText:@"로딩중.."];
        [textLabel setHighlighted:YES];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:textLabel];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
        
        indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(45.0, 15.0, 30.0, 30.0)];
        [self addSubview:indicator];
        [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [indicator startAnimating];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 47.0,  90.0, 30.0)];
        [textLabel setText:@"로딩중.."];
        [textLabel setHighlighted:YES];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[UIFont systemFontOfSize:14.0]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:textLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
