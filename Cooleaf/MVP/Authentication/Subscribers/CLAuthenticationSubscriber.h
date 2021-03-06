//
//  CLAuthenticationSubscriber.h
//  Cooleaf
//
//  Created by Haider Khan on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLBaseSubscriber.h"
#import "CLAuthenticationController.h"
#import "CLAuthenticationEvent.h"
#import "CLAuthenticationSuccessEvent.h"

@interface CLAuthenticationSubscriber : CLBaseSubscriber

- (id)init;

@end