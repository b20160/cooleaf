//
//  CLDetailView.m
//  Cooleaf
//
//  Created by Jonathan Green on 9/4/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLDetailView.h"
#import "UIColor+CustomColors.h"
#import <FXBlurView.h>

@implementation CLDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews {
    
    [self labelWidth:_labelName];
}

- (void)awakeFromNib {
    
    
    
    self.backgroundColor = [UIColor offWhite];
    
    // Background View
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 300)];
    bgview.backgroundColor = [UIColor clearColor];
    
    // Blur
    FXBlurView *blur = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 235, self.frame.size.width, 65)];
    blur.backgroundColor = [UIColor clearColor];
    blur.tintColor = [UIColor blackColor];
    blur.alpha = 0.85;
    
    // Image
    _mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, bgview.frame.size.width,bgview.frame.size.height)];
   _mainImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    //_groupImageView.image = _groupImageView.image;
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    _mainImageView.layer.masksToBounds = YES;
    _mainImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _mainImageView.layer.shouldRasterize = YES;
    _mainImageView.clipsToBounds = YES;
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(60, 255, 0, 0)];
    _labelName.textAlignment = NSTextAlignmentLeft;
    _labelName.text = @"#Prem Bhatia";
    _labelName.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    _labelName.backgroundColor = [UIColor clearColor];
    _labelName.textColor = [UIColor offWhite];
    [_labelName sizeToFit];
    _labelName.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    /**
     *  Join Button
     */
    
    // Join
    _joinBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _joinBtn.frame = CGRectMake(230, 315, 75, 30);
    [_joinBtn setTitle:@"JOIN" forState:UIControlStateNormal];
    _joinBtn.backgroundColor = [UIColor groupNavBarColor];
    _joinBtn.tintColor = [UIColor offWhite];
    _joinBtn.layer.cornerRadius = 2;
    _joinBtn.layer.masksToBounds = YES;
    [_joinBtn addTarget:self action:@selector(joinGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Events
    _eventsBtn = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _eventsBtn.frame = CGRectMake(10, 405, 300, 40);
    [_eventsBtn setTitle:@"Events" forState:UIControlStateNormal];
    _eventsBtn.backgroundColor = [UIColor groupNavBarColor];
    _eventsBtn.tintColor = [UIColor offWhite];
    _eventsBtn.layer.cornerRadius = 2;
    _eventsBtn.layer.masksToBounds = YES;
    
    // eventIcons
    UIImageView *eventsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 410, 25, 25)];
    eventsIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    eventsIcon.image = [UIImage imageNamed:@"WhiteEvents"];
    eventsIcon.contentMode = UIViewContentModeScaleAspectFill;
    eventsIcon.layer.masksToBounds = YES;
    eventsIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    eventsIcon.layer.shouldRasterize = YES;
    eventsIcon.clipsToBounds = YES;
    
    UIImageView *arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(270, 415, 30, 25)];
    arrowIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    arrowIcon.image = [UIImage imageNamed:@"arrow"];
    arrowIcon.contentMode = UIViewContentModeScaleAspectFill;
    arrowIcon.layer.masksToBounds = YES;
    arrowIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
    arrowIcon.layer.shouldRasterize = YES;
    arrowIcon.clipsToBounds = YES;
    
    
    /**
     *  Segmented Control for switching posts and events
     */
    
    // Make the frame for the segmented control
   /* CGRect frame = CGRectMake(10, 405, 300, 30);
    
    // Make array of items for the segmented control
    NSArray *segments = [[NSArray alloc] initWithObjects:@"Posts", @"Events", nil];
    
    // Initialize the segmented control, and set size and index
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
    self.segmentedControl.frame = frame;
    [self.segmentedControl setSelectedSegmentIndex:0];
    
    // Attach target action to the segmented control
    [self.segmentedControl addTarget:self action:@selector(selectSegment:) forControlEvents:UIControlEventValueChanged];
    
    /**
     *  Members button
     */
    
    _members = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    _members.frame  = CGRectMake(230, 380, 80, 10);
    _members.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    [_members setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //[members addTarget:self action:@selector(somefunc:) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *  First border
     */
    
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 400, bgview.frame.size.width, 0.5)];
    border.backgroundColor = [UIColor lightGrayColor];
    
    /**
     *  Second border
     */
    
    UIView *border2 = [[UIView alloc] initWithFrame:CGRectMake(0, 450, bgview.frame.size.width, 0.5)];
    border2.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:bgview];
    [self addSubview:blur];
    [self addSubview:_labelName];
    [self addSubview:_labelEvent];
    [self addSubview:_labelEventSub];
    [self addSubview:_members];
    [self addSubview:_joinBtn];
    [self addSubview:_eventsBtn];
    [self addSubview:eventsIcon];
    [self addSubview:arrowIcon];
    //[self addSubview:_segmentedControl];
    [self addSubview:border];
    [self addSubview:border2];
    [bgview addSubview:_mainImageView];
}

- (void)joinGroup:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(joinGroup:)])
        [self.delegate joinGroup:self];
}

- (void)selectSegment:(UISegmentedControl *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectSegment:)])
        [self.delegate selectSegment:self];
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
