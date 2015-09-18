//
//  CLInterestPresenter.m
//  Cooleaf
//
//  Created by Jonathan Green on 8/26/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLInterestPresenter.h"
#import "CLBus.h"
#import "CLLoadInterests.h"
#import "CLLoadedInterests.h"
#import "CLLoadInterestMembers.h"
#import "CLLoadedInterestMembers.h"

static NSInteger const PAGE = 1;
static NSInteger const PER_PAGE = 25;

@implementation CLInterestPresenter

# pragma mark - Init

- (id)initWithInteractor:(id<IInterestInteractor>)interactor {
    _interestInfo = interactor;
    return self;
}

# pragma mark - Init Detail

- (id)initWithDetailInteractor:(id<IInterestDetailInteractor>)interactor {
    _interestDetailInfo = interactor;
    return self;
}

# pragma mark - Bus Methods

- (void)registerOnBus {
    REGISTER();
}

- (void)unregisterOnBus {
    UNREGISTER();
}

# pragma mark - loadInterests

- (void)loadInterests {
    PUBLISH([[CLLoadInterests alloc] init]);
}

# pragma mark - loadInterestMembers

- (void)loadInterestMembers:(NSInteger)interestId {
    PUBLISH([[CLLoadInterestMembers alloc] initWithId:interestId page:PAGE perPage:PER_PAGE]);
}

# pragma mark - Subscription Events

SUBSCRIBE(CLLoadedInterests) {
    [_interestInfo initInterests:event.interests];
}

SUBSCRIBE(CLLoadedInterestMembers) {
    [_interestDetailInfo initMembers:event.members];
}

@end
