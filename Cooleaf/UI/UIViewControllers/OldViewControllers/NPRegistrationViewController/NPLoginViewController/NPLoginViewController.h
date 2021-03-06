//
//  NPLoginViewController.h
//  Cooleaf
//
//  Created by Bazyli Zygan on 14.12.2013.
//  Copyright (c) 2013 Nova Project. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLBus.h"
#import "CLAuthenticationEvent.h"
#import "IAuthenticationInteractor.h"
#import "IRegistrationInteractor.h"

@interface NPLoginViewController : UIViewController <IRegistrationInteractor, IAuthenticationInteractor, UITextFieldDelegate>

@end
