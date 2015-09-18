//
//  NPClient.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLClient.h"
#import "CLEvent.h"
#import "CLUser.h"
#import "CLInterest.h"
#import "CLQuery.h"

static NSString *const BASE_API_URL = @"http://testorg.staging.do.cooleaf.monterail.eu";
static NSString *const API_URL = @"http://testorg.staging.do.cooleaf.monterail.eu/api";
static NSString *const X_ORGANIZATION = @"X-Organization";

@implementation CLClient

#pragma mark - Initialization

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:[NSURL URLWithString:API_URL]];
    if (!self)
        return nil;
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

# pragma mark - Singleton

+ (CLClient *)getInstance {
    static CLClient *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:API_URL]];
    });
    return _sharedInstance;
}

# pragma mark - modelClassesByResourcePath

/**
 *  Look carefully into this method fix Mantle issues
 *
 *  @return NSDictionary 
 */
+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"v2/authorize.json": [CLUser class],
             @"v2/events/*": [CLEvent class],
             @"v2/users/*": [CLUser class],
             @"v2/users.json": [CLUser class],
             @"v2/interests.json": [CLInterest class],
             @"memberlist.json": [CLUser class],
             @"v3/search.json": [CLQuery class]
             };
}

# pragma mark - responseClassesByResourcePath

+ (NSDictionary *)responseClassesByResourcePath {
    return @{
             
             };
}

# pragma mark - setOrganizationHeader

+ (void)setOrganizationHeader:(NSString *)header {
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:header forHTTPHeaderField:X_ORGANIZATION];
    [self getInstance].requestSerializer = requestSerializer;
}

# pragma mark - getBaseApiURL

+ (NSString *)getBaseApiURL {
    return BASE_API_URL;
}

@end

