//
//  CLGroupViewController.m
//  Cooleaf
//
//  Created by Jonathan Green on 9/3/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CLGroupViewController.h"
#import "UIColor+CustomColors.h"
#import "CLGroupDetailViewController.h"
#import "CLInterestPresenter.h"
#import "CLInterest.h"
#import "CLSearchViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMDrawerController.h"
#import "NPAppDelegate.h"

@interface CLGroupViewController () {
    @private
    UIRefreshControl *_refreshControl;
    CLInterestPresenter *_interestPresenter;
    NSMutableArray *_interests;
    UIColor *_barColor;
}

@end

@implementation CLGroupViewController

# pragma mark - LifeCycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setupSearch];
    [self initPullToRefresh];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupNavBar];
    [self initInterestPresenter];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [_interestPresenter unregisterOnBus];
    _interestPresenter = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - searchDisplay

-(void)setupSearch {
    
    MMDrawerBarButtonItem *drawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(openDrawer)];
    [drawerButton setTintColor:[UIColor whiteColor]];
    
    // Create right navbar buttons
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchViewController)];
    
    NSArray * rightButtons = [NSArray arrayWithObjects:searchBtn, nil];
    
    [[self navigationItem] setRightBarButtonItem:searchBtn];
    [[self navigationItem] setLeftBarButtonItem:drawerButton];
    
    searchBtn.tintColor = [UIColor whiteColor];
}

# pragma mark - initPullToRefresh

- (void)initPullToRefresh {
    _refreshControl = [UIRefreshControl new];
    [_refreshControl addTarget:self action:@selector(reloadInterests) forControlEvents:UIControlEventValueChanged];
    _refreshControl.tintColor = [UIColor groupNavBarColor];
    [self.tableView addSubview:_refreshControl];
    [self.tableView sendSubviewToBack:_refreshControl];
}

# pragma mark - setupNavBar

- (void)setupNavBar {
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    _barColor = [UIColor groupNavBarColor];
    self.navigationController.navigationBar.barTintColor = _barColor;
}

# pragma mark - initInterestPresenter

- (void)initInterestPresenter {
    _interestPresenter = [[CLInterestPresenter alloc] initWithInteractor:self];
    [_interestPresenter registerOnBus];
    [_interestPresenter loadInterests];
    [self showActivityIndicator];
}

# pragma mark - IInterestInteractor Methods

- (void)initInterests:(NSMutableArray *)interests {
    [self hideActivityIndicator];
    
    _interests = interests;
    [self.tableView reloadData];
    
    // If refreshing end refreshing
    if (_refreshControl) {
        [self setAttributedTitle];
        [_refreshControl endRefreshing];
    }
}

# pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _interests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell"];
    
    // Grab interest
    CLInterest *interest = [_interests objectAtIndex:indexPath.row];
    
    // Get name and image
    NSString *name = [interest name];
    CLImage *image = [interest image];
    
    // Get image path
    if ([image url]) {
        NSString *url = [image url];
        NSString *fullPath = [NSString stringWithFormat:@"%@%@", @"http:", url];
        fullPath = [fullPath stringByReplacingOccurrencesOfString:@"{{SIZE}}" withString:@"1600x400"];
    
        // Set image
        [cell.groupImageView sd_setImageWithURL:[NSURL URLWithString:fullPath]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    }
    
    // Set name
    cell.labelName.text = name;
    
    // Set participant count
    cell.labelCount.text = [NSString stringWithFormat:@"%@", [interest userCount]];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toDetail"]) {
        [self goToDetailView:segue];
    }
}

# pragma mark - reloadInterests

- (void)reloadInterests {
    if (_interestPresenter != nil)
        [_interestPresenter loadInterests];
}

# pragma mark - goToDetailView

- (void)goToDetailView:(UIStoryboardSegue *)segue {
    CLGroupDetailViewController *detailView = (CLGroupDetailViewController *)[segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    CLInterest *interest = [_interests objectAtIndex:[indexPath row]];
    CLImage *image = [interest image];
    
    // Get image path
    NSString *url = [image url];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", @"http:", url];
    fullPath = [fullPath stringByReplacingOccurrencesOfString:@"{{SIZE}}" withString:@"1600x400"];

    NSString *currentName = [interest name];
    
    [detailView setInterest:interest];
    [detailView setCurrentImagePath:fullPath];
    [detailView setCurrentName:currentName];
}

- (void)setAttributedTitle {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor groupNavBarColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    _refreshControl.attributedTitle = attributedTitle;
}

- (NSURL *)getInterestImageURL:(NSUInteger)row {
    CLInterest *interest = [_interests objectAtIndex:row];
    CLImage *image = [interest image];
    NSString *url = [image url];
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", @"http:", url];
    fullPath = [fullPath stringByReplacingOccurrencesOfString:@"{{SIZE}}" withString:@"164x164"];
    NSLog(@"%@", fullPath);
    return [NSURL URLWithString:fullPath];
}

# pragma mark - openDrawer

- (void)openDrawer {
    NPAppDelegate *appDelegate = (NPAppDelegate *) [UIApplication sharedApplication].delegate;
    [appDelegate openDrawer];
}

# pragma mark - searchViewController

- (void)searchViewController {
    CLSearchViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [[self navigationController] pushViewController:search animated:YES];
}

# pragma mark - showActivityIndicator

- (void)showActivityIndicator {
    [_activityIndicator setHidden:NO];
    [_activityIndicator setColor:[UIColor colorAccent]];
    [_activityIndicator startAnimating];
}

# pragma mark - hideActivityIndicator

- (void)hideActivityIndicator {
    [_activityIndicator stopAnimating];
    [_activityIndicator setHidden:YES];
}

@end
