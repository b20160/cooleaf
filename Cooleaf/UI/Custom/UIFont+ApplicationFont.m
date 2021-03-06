//
//  UIFont+ApplicationFont.m
//  Cooleaf
//
//  Created by Bazyli Zygan on 19.12.2013.
//  Copyright (c) 2013 Nova Project. All rights reserved.
//

#import "UIFont+ApplicationFont.h"

@implementation UIFont (ApplicationFont)

+ (UIFont *)applicationFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue" size:size];//[UIFont fontWithName:@"AvenirNext-Medium" size:size];
}

+ (UIFont *)mediumApplicationFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)boldApplicationFontOfSize:(CGFloat)size
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

@end
