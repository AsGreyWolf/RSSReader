//
//  RSSChannelTableViewController.m
//  RSSReader
//
//  Created by User on 12/13/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSChannelTableViewController.h"
#import "RSSChannel.h"
#import "RSSTableViewController.h"
#import "RSSChannelTableViewCell.h"
#import "RSSChannelSet.h"
#import "UIViewController+showError.h"

@interface RSSChannelTableViewController () <RSSChannelSetDelegate>{
	int _clickedItem;
	RSSChannelSet *_channelSet;
}

@end


@implementation RSSChannelTableViewController

- (void) update{
	[_channelSet refresh];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UINib *cellNib = [UINib nibWithNibName:@"RSSChannelTableViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"ChannelCell"];
	_clickedItem = -1;

	_channelSet = [RSSChannelSet new];
	_channelSet.delegate = self;

	self.refreshControl = [UIRefreshControl new];
	[self.refreshControl addTarget:self action:@selector(update) forControlEvents:UIControlEventValueChanged];

	[self update];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _channelSet.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
	cell.channel = [_channelSet.channels objectAtIndex:indexPath.row];
	return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
	return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
											forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[_channelSet removeChannel:[_channelSet.channels objectAtIndex:indexPath.row]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	_clickedItem = indexPath.row;
	[self performSegueWithIdentifier:@"RSSChannelDetailSegue" sender:self.tableView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([[segue identifier] hasPrefix:@"RSSChannelDetailSegue"] && _clickedItem>=0){
		RSSTableViewController *controller = [segue destinationViewController];
		controller.channel = [_channelSet.channels objectAtIndex:_clickedItem];
		_clickedItem = -1;
	}
}

- (IBAction)addButtonTapped:(UIBarButtonItem *)sender {
	UIAlertController *dialogController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Add RSS Channel", nil)
																			  message:nil
																	   preferredStyle:UIAlertControllerStyleAlert];
	__block UITextField *urlField;
	[dialogController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		urlField = textField;
		urlField.placeholder = NSLocalizedString(@"URL", nil);
	}];
	[dialogController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
														 style:UIAlertActionStyleCancel
													   handler:nil]];
	[dialogController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Save", nil)
														 style:UIAlertActionStyleDefault
													   handler:^(UIAlertAction *sender){
														   [_channelSet addURL:[NSURL URLWithString:urlField.text]];
													   }]];
	[self presentViewController:dialogController
					   animated:true
					 completion:nil];
}

#pragma mark - RSSChannelSetDelegate


- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didStartRefreshing:(NSArray<RSSChannel*> *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.refreshControl beginRefreshing];
	});

}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didPreloaded:(NSArray<RSSChannel*> *)rssChannel{
	[self RSSChannelSet:RSSChannelSet didFinishRefreshing:rssChannel];
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFinishRefreshing:(NSArray<RSSChannel*> *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.refreshControl endRefreshing];
		[self.tableView reloadData];
		UIApplication.sharedApplication.applicationIconBadgeNumber=RSSChannelSet.unreadCount;
	});
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self showError:err];
		[self.refreshControl endRefreshing];
		[self.tableView reloadData];
	});
}


@end
