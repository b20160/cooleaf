//
//  CLEventSubscriber.m
//  Cooleaf
//
//  Created by Haider Khan on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLEventSubscriber.h"

@implementation CLEventSubscriber

# pragma init

- (id)init {
    _eventController = [[CLEventController alloc] init];
    return self;
}


# pragma subscription events

SUBSCRIBE(CLLoadEvents) {
    [_eventController getEvents:nil success:^(id JSON) {
        NSLog(@"%@", JSON);
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
}

@end