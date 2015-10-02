//
//  NPInterestsViewController.h
//  Cooleaf
//
//  Created by Curtis Jones on 2015.03.12.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IInterestInteractor.h"

@interface NPInterestsViewController2 : UICollectionViewController <IInterestInteractor>

@property (readwrite, assign, nonatomic) BOOL editModeOn;
@property (readwrite, assign, nonatomic) BOOL topBarEnabled;
@property (readwrite, assign, nonatomic) BOOL scrollEnabled;

@end
