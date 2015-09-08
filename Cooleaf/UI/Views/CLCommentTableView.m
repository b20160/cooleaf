//
//  CLCommentTableView.m
//  Cooleaf
//
//  Created by Jonathan Green on 9/8/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLCommentTableView.h"
#import "UIColor+CustomColors.h"

@implementation CLCommentTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.rowHeight = UITableViewAutomaticDimension;
    //self.estimatedRowHeight = 400.0;
    
    
    
    self.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160.0f)];
        bgView.backgroundColor = [UIColor UIColorFromRGB:0xF1F1F1];
        view.backgroundColor = [UIColor offWhite];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 70, 70)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"TestImage"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.layer.borderColor = [UIColor clearColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        //Name
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 0, 0)];
        labelName.textAlignment = NSTextAlignmentLeft;
        labelName.text = @"Prem Bhatia";
        labelName.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        labelName.backgroundColor = [UIColor clearColor];
        labelName.textColor = [UIColor grayColor];
        [labelName sizeToFit];
        labelName.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        //Orginization
        UILabel *labelOrginization = [[UILabel alloc] initWithFrame:CGRectMake(0, 110.5, 0, 0)];
        labelOrginization.textAlignment = NSTextAlignmentLeft;
        labelOrginization.text = @"Cooleaf";
        labelOrginization.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        labelOrginization.backgroundColor = [UIColor clearColor];
        labelOrginization.textColor = [UIColor grayColor];
        [labelOrginization sizeToFit];
        labelOrginization.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        //Rewards
        int myInt = 0;
        UILabel *labelRewards = [[UILabel alloc] initWithFrame:CGRectMake(0, 130.5, 0, 0)];
        labelRewards.textAlignment = NSTextAlignmentLeft;
        labelRewards.text = [NSString stringWithFormat:@"Rewards:%d", myInt];
        labelRewards.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        labelRewards.backgroundColor = [UIColor clearColor];
        labelRewards.textColor = [UIColor grayColor];
        [labelRewards sizeToFit];
        labelRewards.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:bgView];
        [view addSubview:imageView];
        [view addSubview:labelName];
        [view addSubview:labelOrginization];
        [view addSubview:labelRewards];
        view;
    });
    
}

@end
