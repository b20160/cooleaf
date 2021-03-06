//
//  CLGroupEventCell.m
//  Cooleaf
//
//  Created by Jonathan Green on 9/16/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLGroupEventCell.h"
#import "UIColor+CustomColors.h"
#import "LabelWidth.h"

@implementation CLGroupEventCell

-(void)layoutSubviews {
    
    [self labelWidth:_eventTitleLabel];
}

- (void)awakeFromNib {
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mainImage.clipsToBounds = YES;
    self.bgView.backgroundColor = [UIColor offWhite];
    self.eventTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.eventTitleLabel.textColor = [UIColor offWhite];
    self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    self.dateLabel.textColor = [UIColor offWhite];
    self.rewardsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    self.rewardsLabel.textColor = [UIColor offWhite];
    self.eventDescription.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    self.eventDescription.textColor = [UIColor grayColor];
    self.commentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
    self.commentLabel.textColor = [UIColor lightGrayColor];
    self.participansLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
     self.participansLabel.textColor = [UIColor lightGrayColor];
    [self.commentBtn setTitle:@"COMMENT" forState:UIControlStateNormal];
    self.commentBtn.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
   [self.leaveBtn setTitle:@"LEAVE" forState:UIControlStateNormal];
    self.leaveBtn.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)labelWidth:(UILabel *)theLabel {
    
    // use this for custom font
    // CGFloat width =  [theLabel.text sizeWithFont:[UIFont fontWithName:@"ChaparralPro-Bold" size:40 ]].width;
    
    // Use this for system font
    CGFloat width =  [theLabel.text sizeWithFont:[UIFont systemFontOfSize:40 ]].width;
    theLabel.frame = CGRectMake(theLabel.frame.origin.x, theLabel.frame.origin.y, width, theLabel.frame.size.height);
    
    // point.x, point.y -> origin for label;
    // height -> your label height;
}


@end
