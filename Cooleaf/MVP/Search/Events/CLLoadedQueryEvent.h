//
//  CLLoadedQueryEvent.h
//  Cooleaf
//
//  Created by Haider Khan on 9/14/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLLoadedQueryEvent : NSObject

@property (nonatomic, assign) NSMutableArray *results;

- (id)initWithResults:(NSMutableArray *)results;

@end
