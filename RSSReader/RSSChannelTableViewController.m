//
//  RSSChannelTableViewController.m
//  RSSReader
//
//  Created by User on 12/13/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSChannelTableViewController.h"
#import "RSSChannel.h"
#import "RSSNewsModel+CoreDataClass.h"
#import "NSManagedObjectContext+contextWithSqlite.h"
#import "RSSTableViewController.h"
#import "RSSChannelTableViewCell.h"
#import "RSSCachedSource.h"

@interface RSSChannelTableViewController () <RSSSourceDelegate>{
	NSArray <RSSChannel*> *_channels;
	int _clickedItem;
	NSMutableSet <RSSSource*> *_processingSources;
	UIRefreshControl *_refreshControl;
}

- (void)addUrl:(NSURL*)url;
- (void)removeUrl:(NSURL*)url;
- (void)showError:(NSError *)err;

@end


@implementation RSSChannelTableViewController

- (void)showError:(NSError *)err{
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
																	message:NSLocalizedString(@"Can not load RSS", nil)
															 preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)
											   style:UIAlertActionStyleDestructive
											 handler:nil]];
	[self presentViewController:alert animated:true completion:nil];
}

- (void)addUrl:(NSURL *)url{
	if(url==nil){
		[self showError:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
											code:43
										userInfo:nil]];
	}
	RSSSource *src = [RSSCachedSource sourceWithURL:url];
	src.delegate = self;
	[_processingSources addObject:src];
	[src refresh];
}

- (void)removeUrl:(NSURL *)url{
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSManagedObjectContext *context = [NSManagedObjectContext contextWithSharedContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url like %@",[url absoluteString]];
		NSError *dbError;
		NSArray <RSSChannelModel*> *dbResult = [context executeFetchRequest:fetchRequest
																	  error:&dbError];
		NSAssert(dbError==nil, @"Database selection failed");
		for(RSSChannelModel *dbChannel in dbResult)
			[context deleteObject:dbChannel];
		[context save:&dbError];
		NSAssert(dbError==nil, @"Database save failed");
		dispatch_async(dispatch_get_main_queue(), ^{
			NSError *dbError;
			[[NSManagedObjectContext mainContext] save:&dbError];
			NSAssert(dbError==nil, @"Database save failed");
			[self update];
		});
	});
}

- (void)update{
	[_refreshControl beginRefreshing];
	NSManagedObjectContext *context = [NSManagedObjectContext mainContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
	NSError *dbError;
	NSArray <RSSChannelModel*> *dbChannels = [context executeFetchRequest:fetchRequest
																	error:&dbError];
	NSAssert(dbError==nil, @"Database selection failed");
	dbChannels = [dbChannels sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
																						 ascending:true]]];
	NSMutableArray <RSSChannel*> *channels = [NSMutableArray new];
	for(RSSChannelModel *dbChannel in dbChannels){
		int count = 0;
		for(RSSNewsModel *dbNews in dbChannel.news){
			if(!dbNews.read) count++;
		}
		[channels addObject:[RSSChannel channelWithModel:dbChannel]];
	}
	_channels = channels;
	[_refreshControl endRefreshing];
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UINib *cellNib = [UINib nibWithNibName:@"RSSChannelTableViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"ChannelCell"];
	_clickedItem = -1;
	_processingSources = [NSMutableSet new];
	_refreshControl = [[UIRefreshControl alloc]init];
	[self.tableView addSubview:_refreshControl];
	[_refreshControl addTarget:self action:@selector(update) forControlEvents:UIControlEventValueChanged];
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
    RSSChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelCell" forIndexPath:indexPath];
	cell.channel = [_channels objectAtIndex:indexPath.row];
	return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
	return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
											forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self removeUrl:[_channels objectAtIndex:indexPath.row].url];
		//[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
		controller.channel = [_channels objectAtIndex:_clickedItem];
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
														   [self addUrl:[NSURL URLWithString:urlField.text]];
													   }]];
	[self presentViewController:dialogController
					   animated:true
					 completion:nil];
}

#pragma mark - RSSSourceDelegate

- (void)RSSSource:(RSSSource *)RSSSource didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		if([_processingSources containsObject:RSSSource])
			[_processingSources removeObject:RSSSource];
		[self showError:err];
	});
}

- (void)RSSSource:(RSSSource *)RSSSource didStartRefreshing:(NSURL *)url{
}

- (void)RSSSource:(RSSSource *)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		if([_processingSources containsObject:RSSSource])
			[_processingSources removeObject:RSSSource];
		[self update];
	});
}


@end
