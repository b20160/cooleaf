//
//  CLDrawerViewController.m
//  Cooleaf
//
//  Created by Haider Khan on 8/31/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLDrawerViewController.h"

static NSString *const kTAG = @"CLDrawerViewController";

@interface CLDrawerViewController ()

@end

@implementation CLDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkAuthentication];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark checkAuthentication

- (void)checkAuthentication {
    [self goToLogin];
}

# pragma mark goToLogin

- (void)goToLogin {
    NPLoginViewController *loginViewController = [[NPLoginViewController alloc] init];
    [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
