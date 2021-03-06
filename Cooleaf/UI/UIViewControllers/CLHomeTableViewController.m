//
//  CLHomeTableViewController.m
//  Cooleaf
//
//  Created by Haider Khan on 8/31/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <UIViewController+MMDrawerController.h>
#import "CLHomeTableViewController.h"
#import "UIColor+CustomColors.h"
#import "CLProfileTableViewController.h"
#import "CLAuthenticationPresenter.h"
#import "CLEventPresenter.h"
#import "CLEvent.h"
#import "CLClient.h"
#import "CLSearchViewController.h"
#import "CLEventController.h"
#import "NPAppDelegate.h"
#import "CLCommentViewController.h"
#import "CLEventDetailViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "NPLoginViewController.h"
#import "CLUserPresenter.h"
#import "SSKeychain.h"
#import "CLInterestsCollectionViewController.h"
#import "NPInterestsViewController2.h"
#import "CLPostViewController.h"

#define StringFromBoolean (return value ? @"YES" : @"NO")

@interface CLHomeTableViewController() {
    @private
    CLAuthenticationPresenter *_authPresenter;
    CLUserPresenter *_userPresenter;
    CLEventPresenter *_eventPresenter;
    NSMutableArray *_events;
    UIColor *barColor;
}

@end

@implementation CLHomeTableViewController

# pragma mark - UIViewController LifeCycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Checks for user login - this can be done better
    if (![self isLoggedIn] && [self hasUserCredentials]) {
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [SSKeychain passwordForService:@"cooleaf" account:username];
        [_authPresenter authenticate:username :password];
    }
    
    if (![_currentView isEqualToString:@"My Events"] && ![self hasUserCredentials] && ![self isLoggedIn]) {
        [self showLogin];
    }
    
    // Hide activity indicator
    [_activityIndicator setHidden:YES];
    
    // Init bar display
    [self setupDisplay];

    [self initViews];
    [self initUserImageGestureRecognizer];
    
    // Init pull to refresh
    [self initPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self hasUserCredentials])
        [self setupNavBar];
    else
        [self showLogin];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Initialize Auth Presenter
    if (!_authPresenter)
        [self initAuthPresenter];
    // Initialize User Presenter
    [self setupUserPresenter];
    
    // Initialize Event presenter
    [self initEventPresenter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_authPresenter unregisterOnBus];
    [_userPresenter unregisterOnBus];
    [_eventPresenter unregisterOnBus];
    _authPresenter = nil;
    _userPresenter = nil;
    _eventPresenter = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Init Presenters

- (void)initAuthPresenter {
    _authPresenter = [[CLAuthenticationPresenter alloc] initWithInteractor:self];
    [_authPresenter registerOnBus];
}

- (void)initEventPresenter {
    _eventPresenter = [[CLEventPresenter alloc] initWithInteractor:self];
    [_eventPresenter registerOnBus];
}

- (void)setupUserPresenter {
    // Initialize user presenter
    _userPresenter = [[CLUserPresenter alloc] initWithInteractor:self];
    [_userPresenter registerOnBus];
    [_userPresenter loadMe];
    [self showActivityIndicator];
}

#pragma mark - setupDisplay

- (void)setupDisplay {
    
    if ([_currentView isEqualToString:@"My Events"])
        self.navigationController.navigationBar.topItem.title = @"My Events";
    else
        self.navigationController.navigationBar.topItem.title = @"Home";
    
    self.navigationController.navigationBar.alpha = 1;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    MMDrawerBarButtonItem *drawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(openDrawer)];
    [drawerButton setTintColor:[UIColor whiteColor]];
    
    // Create right navbar buttons
    UIBarButtonItem *searchBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchViewController)];
    
    NSArray *rightButtons = [NSArray arrayWithObjects:searchBtn, nil];
    [[self navigationItem] setRightBarButtonItems:(rightButtons) animated:YES];
    [[self navigationItem] setLeftBarButtonItem:drawerButton];
    
    searchBtn.tintColor = [UIColor whiteColor];
}

# pragma mark - setupNavBar

- (void)setupNavBar {
    // Set bar color
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
    self.navigationController.navigationBar.tintColor = [UIColor colorPrimary];
    // Searchbar color
    barColor = [UIColor colorPrimary];
}

# pragma mark - postViewController

- (void)postViewController {
    CLPostViewController *post = [self.storyboard instantiateViewControllerWithIdentifier:@"Post"];
    [[self navigationController] presentViewController:post animated:YES completion:nil];
}

#pragma mark - toggleSearch

- (void)toggleSearch {
    [self.tableView addSubview:self.searchBar];
    [self.searchController setActive:YES animated:YES];
    [self.searchBar becomeFirstResponder];
    self.searchBar.barTintColor = barColor;
}

# pragma mark - searchViewController

- (void)searchViewController {
    CLSearchViewController *search = [self.storyboard instantiateViewControllerWithIdentifier:@"search"];
    [[self navigationController] pushViewController:search animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Profile Segue"]) {
        ((CLProfileTableViewController *) segue.destinationViewController).user = _user;
    }
}

# pragma mark - CLEventCellDelegate

- (void)didPressComment:(CLEventCell *)cell {
    // Get the indexpath and event
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CLEvent *event = [_events objectAtIndex:[indexPath row]];
    
    // Instantiate comment controller and assign event
    CLCommentViewController *commentController = [self.storyboard instantiateViewControllerWithIdentifier:@"commentController"];
    [commentController setEvent:event];
    [commentController setBackgroundImage:cell.eventImage];
    [commentController setUserId:[_user userId]];
    [[self navigationController] presentViewController:commentController animated:YES completion:nil];
}

- (void)didPressJoin:(CLEventCell *)cell {
    // Get the indexpath and event
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    CLEvent *event = [_events objectAtIndex:[indexPath row]];
    
    BOOL attending = [event isAttending];
    if (attending)
        [_eventPresenter leaveEvent:[[event eventId] integerValue]];
    else
        [_eventPresenter joinEvent:[[event eventId] integerValue]];
}

# pragma mark - IUserInteractor Methods

- (void)initMe:(id)user {
    [self hideActivityIndicator];
    // Init user to the navigation drawer
    [((NPAppDelegate *) [UIApplication sharedApplication].delegate) setUserInDrawer:user];
    
    _user = user;
    [self initProfileHeaderWithUser:_user];
    if (_currentView == nil) {
        [_eventPresenter loadEvents];
    } else {
        NSString *userIdString = [NSString stringWithFormat:@"%d", [[_user userId] intValue]];
        [_eventPresenter loadUserEvents:@"ongoing" userIdString:userIdString];
    }

}

- (void)initOrganizationUsers:(NSMutableArray *)organizationUsers {
    
}

# pragma mark - IAuthenticationInteractor methods

- (void)initUser:(CLUser *)user {
    [self hideActivityIndicator];
    // Init user to the navigation drawer
    [((NPAppDelegate *) [UIApplication sharedApplication].delegate) setUserInDrawer:user];
    
    _user = user;
    [self initProfileHeaderWithUser:_user];
    if (_currentView == nil) {
        [_eventPresenter loadEvents];
    } else {
        NSString *userIdString = [NSString stringWithFormat:@"%d", [[_user userId] intValue]];
        [_eventPresenter loadUserEvents:@"ongoing" userIdString:userIdString];
    }
}

- (void)deAuthorized {
    [self showLogin];
}

# pragma mark - IEventInteractor methods

- (void)joinedEvent {
    NSLog(@"Joined Event");
}

- (void)leftEvent {
    NSLog(@"Left Event");
}

- (void)initEvents:(NSMutableArray *)events {
    // Events receieved here, set into tableview
    _events = [[NSMutableArray alloc] initWithArray:events];
    [self.tableView reloadData];
    
    // If refreshing end refreshing
    if (self.refreshControl) {
        [self setAttributedTitle];
        [self.refreshControl endRefreshing];
    }
}

- (void)initUserEvents:(NSMutableArray *)userEvents {
    _events = [[NSMutableArray alloc] initWithArray:userEvents];
    [self.tableView reloadData];
    
    // If refreshing end refreshing
    if (self.refreshControl) {
        [self setAttributedTitle];
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    // Set cell shadow
    cell.layer.shadowOpacity = 0.75f;
    cell.layer.shadowRadius = 1.0;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.zPosition = 777;
        
    // Get the event
    CLEvent *event = [_events objectAtIndex:[indexPath row]];
    
    // Get the dictionary
    NSDictionary *eventDict = [event dictionaryValue];
        
    // Get the image url
    CLImage *eventImage = [event eventImage];
    NSString *imageUrl = eventImage.url;
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", @"http:", imageUrl];
    fullPath = [fullPath stringByReplacingOccurrencesOfString:@"{{SIZE}}" withString:@"500x200"];
        
    // Set it into the imageview
    [cell.eventImage sd_setImageWithURL:[NSURL URLWithString:fullPath]
                       placeholderImage:[UIImage imageNamed:@"CoverPhotoPlaceholder"]];
        
    // Get the event description
    NSString *eventDescription = [event eventDescription];
        
    cell.eventDescription.text = eventDescription;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLEventCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Instantiate EventDetailViewController and set current event
    CLEventDetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"eventDetail"];
    
    // Set the event
    CLEvent *currentEvent = [_events objectAtIndex:[indexPath row]];
    [detailViewController setEvent:currentEvent];
    [detailViewController setEventImageView:cell.eventImage];
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - Helper Methods

- (void)initViews {
    // Init nav bar color
    self.navigationController.navigationBar.barTintColor = [UIColor colorPrimary];
    self.navigationController.navigationBar.tintColor = [UIColor colorPrimaryDark];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 600.0;
}

- (void)initUserImageGestureRecognizer {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.delegate = self;
    [_userImage addGestureRecognizer:tapRecognizer];
    _userImage.userInteractionEnabled = YES;
}

- (void)onTap {
    // Go to profile view controller
    [self goToProfileView];
}

- (void)goToProfileView {
    [self performSegueWithIdentifier:@"Profile Segue" sender:self];
}

- (void)initPullToRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor colorAccent];
    [self.refreshControl addTarget:self
                            action:@selector(reloadEvents)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)initProfileHeaderWithUser:(CLUser *)user {
    _userNameLabel.text = [user userName];
    _userRewardsLabel.text = [NSString stringWithFormat:@"%@ %@", @"Reward Points:", [[user rewardPoints] stringValue]];
    
    // Get user dictionary
    NSDictionary *userDict = [user dictionaryValue];
    
    // Get credentuals from dictionary
    _userCredentialsLabel.text = userDict[@"role"][@"organization"][@"name"];
    
    NSString *fullImagePath = [NSString stringWithFormat:@"%@%@", [CLClient getBaseApiURL], userDict[@"profile"][@"picture"][@"original"]];
    [_userImage sd_setImageWithURL:[NSURL URLWithString: fullImagePath] placeholderImage:[UIImage imageNamed:@"AvatarPlaceholderMaleMedium"]];
    _userImage.layer.cornerRadius = _userImage.frame.size.width / 2;
    _userImage.clipsToBounds = YES;
}

- (void)reloadEvents {
    // If current view is nil load ongoing events, else load user's events - they are in My Events
    if (_currentView == nil) {
        [_eventPresenter loadEvents];
    } else {
        NSString *userIdString = [NSString stringWithFormat:@"%d", [[_user userId] intValue]];
        [_eventPresenter loadUserEvents:@"ongoing" userIdString:userIdString];
    }
}

- (void)displayEmptyMessage {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    messageLabel.text = @"No events currently available. Please pull down to refresh.";
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:12];
    [messageLabel sizeToFit];
    
    self.tableView.backgroundView = messageLabel;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setAttributedTitle {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor colorAccent]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
}

# pragma mark - openDrawer

- (void)openDrawer {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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

# pragma mark - showLogin

- (void)showLogin {
    NPLoginViewController *loginViewController = [[NPLoginViewController alloc] init];
    [self.navigationController presentViewController:loginViewController animated:YES completion:nil];
}

# pragma mark - hasUserCredentials

- (BOOL)hasUserCredentials {
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [SSKeychain passwordForService:@"cooleaf" account:username];
    return (username != nil) && (password != nil);
}

# pragma mark - isLoggedIn

- (BOOL)isLoggedIn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
}

@end
