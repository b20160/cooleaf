//
//  CLEventPresenter.h
//  Cooleaf
//
//  Created by Haider Khan on 8/25/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventInfo;

@interface CLEventPresenter : NSObject
@property(nonatomic, strong) id<EventInfo> eventInfo;

-(CLEventPresenter *)initWithEventInfo:(id <EventInfo>)eventInfo;

- (void)setEventId:(NSUInteger *) objectId;
- (void)setEventName:(NSString *) name;
- (void)setEventParticipants:(NSDictionary *)eventParticipants;
- (void)setEventStartTime:(NSString *)eventStartTime;
- (void)setEventRewardPoints:(int)eventRewardPoints;
- (void)setIsAttending:(BOOL)isAttending;
- (void)setIsJoinable:(BOOL)isJoinable;

@end
