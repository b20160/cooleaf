//
//  CLInformationTableViewHeader.m
//  Cooleaf
//
//  Created by Haider Khan on 9/8/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLInformationTableViewHeader.h"

@implementation CLInformationTableViewHeader

- (IBAction)expandCollapse:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didPressExpandCollapseButton:)]) {
        [self.delegate didPressExpandCollapseButton:self];
    }
}

@end
