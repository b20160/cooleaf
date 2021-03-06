//
//  NPTodoViewController.m
//  Cooleaf
//
//  Created by Bazyli Zygan on 07.01.2014.
//  Copyright (c) 2014 Nova Project. All rights reserved.
//

#import "NPTodoViewController.h"
#import "NPTodoCell.h"
#import "NPNewTodoViewController.h"
#import "NPCooleafClient.h"

@interface NPTodoViewController ()
{
    NSDictionary *_todosNode;
    NSMutableDictionary *_operations;
    NPNewTodoViewController *_newTodoController;
}

@property (weak, nonatomic) IBOutlet UILabel *emptyPlaceholder;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)addTodoTapped:(id)sender;
@end

@implementation NPTodoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"To Be Done", @"Todo view title");
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"] style:UIBarButtonItemStylePlain target:self action:@selector(addTodoTapped:)];
        _operations = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"NPTodoCell" bundle:nil] forCellReuseIdentifier:@"NPTodoCell"];
    // We need to find a todos node to show up
    [self refreshTodoList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTodoTapped:(id)sender
{
    if (_newTodoController)
    {
        [_newTodoController removeObserver:self forKeyPath:@"event"];
        _newTodoController = nil;
    }
    NPNewTodoViewController *nT = [NPNewTodoViewController new];
    nT.event = _event;
    [nT addObserver:self forKeyPath:@"event" options:NSKeyValueObservingOptionNew context:NULL];
    _newTodoController = nT;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:nT] animated:YES completion:nil];
}

- (void)refreshTodoList
{
    for (NSDictionary *widget in _event[@"widgets"])
    {
        if ([widget[@"type"] isEqualToString:@"todo"])
        {
            _todosNode = widget;
            break;
        }
    }
    
    // Now we can do the rest
    if ([_todosNode[@"propositions"] count] > 0)
    {
        _emptyPlaceholder.hidden = YES;
        _tableView.hidden = NO;
        [_tableView reloadData];
    }
    else
    {
        _emptyPlaceholder.hidden = NO;
        _tableView.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath compare:@"event"] == NSOrderedSame && [object isKindOfClass:[NPNewTodoViewController class]])
    {
        self.event = [(NPNewTodoViewController *)object event];
        [self refreshTodoList];
    }
}

- (void)dealloc
{
    if (_newTodoController)
    {
        [_newTodoController removeObserver:self forKeyPath:@"event"];
    }
}

#pragma mark - UITableView stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_todosNode[@"propositions"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NPTodoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NPTodoCell"];
    
    cell.todo = _todosNode[@"propositions"][indexPath.row];
    
    if (_operations[cell.todo[@"id"]])
        cell.progress = YES;
    
    if (!cell.careActionBlock)
        cell.careActionBlock = ^(NSDictionary *todo, BOOL care) {
            if (!_operations[todo[@"id"]])
            {
                _operations[todo[@"id"]] = [[NPCooleafClient sharedClient] markTodo:todo[@"id"] asDone:care completion:^(NSError *error) {
                   if (!error)
                   {
                       _operations[todo[@"id"]] = [[NPCooleafClient sharedClient] fetchEventWithId:_event[@"id"] completion:^(NSDictionary *eventDetails) {
                           _event = eventDetails;
                           [self refreshTodoList];
                           [_operations removeObjectForKey:todo[@"id"]];
                       }];
                   }
                   else
                   {
                       [_operations removeObjectForKey:todo[@"id"]];
                       [_tableView reloadData];
                   }
                }];
            }
        };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NPTodoCell cellHeightForTodo:_todosNode[@"propositions"][indexPath.row]];
}


@end
