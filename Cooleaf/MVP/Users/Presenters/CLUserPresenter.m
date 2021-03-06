//
//  CLUserPresenter.m
//  Cooleaf
//
//  Created by Haider Khan on 9/15/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLUserPresenter.h"
#import "CLBus.h"
#import "CLLoadUsersEvent.h"
#import "CLLoadedUsersEvent.h"
#import "CLLoadMeEvent.h"
#import "CLLoadedMeEvent.h"
#import "CLSaveUserInterestsEvent.h"
#import "CLSavedUserInterestsEvent.h"

static NSInteger const PAGE = 1;
static NSInteger const PER_PAGE = 25;

@implementation CLUserPresenter

# pragma mark - Init

- (id)initWithInteractor:(id<IUserInteractor>)interactor {
    _userInfo = interactor;
    return self;
}

# pragma mark - Bus Methods

- (void)registerOnBus {
    REGISTER();
    NSLog(@"Registered on bus");
}

- (void)unregisterOnBus {
    UNREGISTER();
    NSLog(@"Unregistered on bus");
}

# pragma mark - loadMe

- (void)loadMe {
    PUBLISH([[CLLoadMeEvent alloc] init]);
}

# pragma mark - loadOrganizationUsers

- (void)loadOrganizationUsers {
    CLLoadUsersEvent *loadUsersEvent = [[CLLoadUsersEvent alloc] initWithPage:PAGE perPage:PER_PAGE];
    PUBLISH(loadUsersEvent);
}

# pragma mark - saveUserInterests

- (void)saveUserInterests:(CLUser *)user activeInterests:(NSMutableArray *)activeInterests fileCache:(NSString *)fileCache {
    PUBLISH([[CLSaveUserInterestsEvent alloc] initWithUser:user activeInterests:activeInterests fileCache:fileCache]);
}

# pragma mark - Subscription Methods

SUBSCRIBE(CLLoadedUsersEvent) {
    if ([_userInfo respondsToSelector:@selector(initOrganizationUsers:)])
        [_userInfo initOrganizationUsers:event.users];
}

SUBSCRIBE(CLLoadedMeEvent) {
    if ([_userInfo respondsToSelector:@selector(initMe:)])
        [_userInfo initMe:event.user];
}

SUBSCRIBE(CLSavedUserInterestsEvent) {
    NSLog(@"CLSavedUserInterestsEvent in presenter");
    if ([_userInfo respondsToSelector:@selector(initSavedUser:)])
        [_userInfo initSavedUser:event.user];
}

@end
