//
//  NPSeriesEventSelectionViewController.m
//  Cooleaf
//
//  Created by Dirk R on 4/5/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "NPSeriesEventSelectionViewController.h"
#import "NPEventSeriesDateCell.h"
#import "NPCooleafClient.h"
#import "NPSeriesEvent.h"

static NSString * const reuseIdentifier = @"dateCell";


@interface NPSeriesEventSelectionViewController ()
{
	NSArray *_npSeriesEvents;
//	NSNumber *_eventID;
}
@end

@implementation NPSeriesEventSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.tableView registerNib:[UINib nibWithNibName:@"NPEventSeriesDateCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView:)];
	self.navigationItem.rightBarButtonItem = rightButton;
	
	[self reload];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reload
{
	[[NPCooleafClient sharedClient] fetchSeriesEventsForEventWithId:_eventID completion:^(NSArray *seriesEventData) {
		_npSeriesEvents = seriesEventData;
		DLog(@"Series Event Data = %@", seriesEventData);
		[self.tableView reloadData];
	}];
}


- (void)viewWillAppear:(BOOL)animated
{
	[self reload];
}


- (IBAction)dismissView:(id)sender {
	DLog(@"Dismiss pressed");
	
	NSArray *activeEvents = [_npSeriesEvents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^ BOOL (NPSeriesEvent *npSeriesEvent, NSDictionary *bindings) { return npSeriesEvent.isAttending; }]];
	
	NSMutableArray *eventIds = [[NSMutableArray alloc] init];
	
	[activeEvents enumerateObjectsUsingBlock:^(NPSeriesEvent *event, NSUInteger index, BOOL *stop) {
		[eventIds addObject:@(event.objectId)];
	}];
	[[NPCooleafClient sharedClient] joinSeriesIDWithEventIdsArray:_seriesID eventIdsArray:eventIds completion:^(NSError *error) {
		DLog(@"Error setting events = %@", error);
				[self.navigationController popViewControllerAnimated:TRUE];
	}];


}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _npSeriesEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NPEventSeriesDateCell *cell = (NPEventSeriesDateCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

	cell.event = _npSeriesEvents[indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	DLog(@"Cell.seriesEvent = %@",cell.event);
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
