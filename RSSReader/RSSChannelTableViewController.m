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
#import "RSSCachedSource.h"

@interface RSSChannelTableViewController () <RSSSourceDelegate>{
	NSArray <RSSChannel*> *_channels;
	NSArray <NSNumber*> *_unreadCount;
	int _clickedItem;
	NSMutableSet <RSSSource*> *_processingSources;
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
		if(dbError!=nil){
			NSLog(@"%@",dbError);
			abort();
		}
		for(RSSChannelModel *dbChannel in dbResult)
			[context deleteObject:dbChannel];
		if(![context save:&dbError]){
			NSLog(@"%@",dbError);
			abort();
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			NSError *dbError;
			if(![[NSManagedObjectContext mainContext] save:&dbError]){
				NSLog(@"%@",dbError);
				abort();
			}
			[self update];
		});
	});
}

- (void)update{
	NSManagedObjectContext *context = [NSManagedObjectContext mainContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
	NSError *dbError;
	NSArray <RSSChannelModel*> *dbChannels = [context executeFetchRequest:fetchRequest
																	error:&dbError];
	dbChannels = [dbChannels sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
																						 ascending:true]]];
	if(dbError!=nil){
		NSLog(@"%@",dbError);
		abort();
	}
	NSMutableArray <RSSChannel*> *channels = [NSMutableArray new];
	NSMutableArray <NSNumber*> *unreadCount = [NSMutableArray new];
	for(RSSChannelModel *dbChannel in dbChannels){
		int count = 0;
		for(RSSNewsModel *dbNews in dbChannel.news){
			if(!dbNews.read) count++;
		}
		[unreadCount addObject:[NSNumber numberWithInt:count]];
		[channels addObject:[RSSChannel channelWithModel:dbChannel]];
	}
	_unreadCount = unreadCount;
	_channels = channels;
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	_clickedItem = -1;
	_processingSources = [NSMutableSet new];
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
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																						   action:@selector(cellTapped:)];
	tapGestureRecognizer.numberOfTapsRequired = 1;
	tapGestureRecognizer.numberOfTouchesRequired = 1;
	cell.tag = indexPath.row;
	[cell addGestureRecognizer:tapGestureRecognizer];

	UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self
																					   action:@selector(cellLongPressed:)];
	lpgr.minimumPressDuration = 0.5;
	[cell addGestureRecognizer:lpgr];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)cellLongPressed:(UILongPressGestureRecognizer *)recognizer
{
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[recognizer locationInView:self.tableView]];
		UIAlertController *dialogController = [UIAlertController alertControllerWithTitle:nil
																				  message:nil
																		   preferredStyle:UIAlertControllerStyleActionSheet];
		[dialogController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Delete", nil)
															 style:UIAlertActionStyleDestructive
														   handler:^(UIAlertAction *sender){
															   [self removeUrl:[_channels objectAtIndex:indexPath.row].url];
														   }]];
		[dialogController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
															 style:UIAlertActionStyleCancel
														   handler:nil]];
		[self presentViewController:dialogController
						   animated:true
						 completion:nil];
	}
}

- (void)cellTapped:(UITapGestureRecognizer*)recognizer
{
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[recognizer locationInView:self.tableView]];
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
