//
//  RSSChannelTableViewController.m
//  RSSReader
//
//  Created by User on 12/13/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSChannelTableViewController.h"
#import "RSSChannelModel+CoreDataClass.h"
#import "RSSNewsModel+CoreDataClass.h"
#import "NSManagedObjectContext+contextWithSqlite.h"
#import "RSSTableViewController.h"

@interface RSSChannelTableViewController (){
	NSArray <RSSChannelModel*> *_channels;
	NSArray <NSNumber*> *_unreadCount;
	NSURL *_clickedUrl;
}

- (void)update;

@end

@implementation RSSChannelTableViewController

- (void)update{
	NSManagedObjectContext *context = [NSManagedObjectContext mainContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
	NSError *dbError;
	_channels = [context executeFetchRequest:fetchRequest
									   error:&dbError];
	if(dbError!=nil){
		NSLog(@"%@",dbError);
		abort();
	}
	NSMutableArray *unreadCount = [NSMutableArray new];
	for(RSSChannelModel *dbChannel in _channels){
		int count = 0;
		for(RSSNewsModel *dbNews in dbChannel.news){
			if(!dbNews.read) count++;
		}
		[unreadCount addObject:[NSNumber numberWithInt:count]];
	}
	_unreadCount = unreadCount;
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_clickedUrl = nil;
	[self update];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _channels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
	cell.textLabel.text = [_channels objectAtIndex:indexPath.row].name;
	if([[_unreadCount objectAtIndex:indexPath.row] integerValue]>0){
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	}
	else{
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    return cell;
}

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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_clickedUrl = [NSURL URLWithString:[_channels objectAtIndex:indexPath.row].url];
	[self performSegueWithIdentifier:@"RSSChannelDetailSegue" sender:tableView];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([[segue identifier] hasPrefix:@"RSSChannelDetailSegue"]){
		RSSTableViewController *controller = [segue destinationViewController];
		controller.url = _clickedUrl;
		_clickedUrl = nil;
	}
}


@end
