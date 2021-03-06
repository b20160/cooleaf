//
//  CLUserPresenter.h
//  Cooleaf
//
//  Created by Haider Khan on 9/15/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserInteractor.h"

@interface CLUserPresenter : NSObject

@property (nonatomic, assign) id<IUserInteractor> userInfo;

- (id)initWithInteractor:(id<IUserInteractor>)interactor;
- (void)registerOnBus;
- (void)unregisterOnBus;
- (void)loadMe;
- (void)loadOrganizationUsers;
- (void)saveUserInterests:(CLUser *)user activeInterests:(NSMutableArray *)activeInterests fileCache:(NSString *)fileCache;

@end
