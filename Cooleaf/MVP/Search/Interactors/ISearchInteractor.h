//
//  ISearchInteractor.h
//  Cooleaf
//
//  Created by Haider Khan on 9/29/15.
//  Copyright © 2015 Nova Project. All rights reserved.
//

@protocol ISearchInteractor <NSObject>

- (void)initWithQueryResults:(NSMutableArray *)results;

@end