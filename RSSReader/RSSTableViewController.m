//
//  RSSTableViewController.m
//  RSSReader
//
//  Created by User on 11/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSTableViewController.h"
#import "RSSNews.h"
#import "RSSTableViewCell.h"
#import "RSSDetailViewController.h"
#import "RSSChannelTableViewController.h"
#import "RSSCachedSource.h"
#import "UIViewController+showError.h"

@interface RSSTableViewController () <RSSSourceDelegate>{
	RSSSource *_rssSource;
	int _clickedItem;
}

@end


@implementation RSSTableViewController

-(void)setChannel:(RSSChannel *)channel{
	_rssSource = [RSSCachedSource sourceWithURL:channel.url];
	_rssSource.delegate = self;
	if(self.viewLoaded)
		[_rssSource refresh];

	_channel = channel;
	self.title = _channel.name;
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UINib *cellNib = [UINib nibWithNibName:@"RSSTableViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"NewsCell"];

	_clickedItem = -1;

	self.refreshControl = [UIRefreshControl new];
	[self.refreshControl addTarget:_rssSource action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[_rssSource refresh];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([[segue identifier] hasPrefix:@"RSSNewsDetailSegue"]){
		RSSDetailViewController *controller = [segue destinationViewController];
		controller.news = [self.channel.news objectAtIndex:_clickedItem];
	}
}

- (IBAction)unwindFromDetail:(UIStoryboardSegue*)sender{
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_clickedItem
																inSection:0]]
						  withRowAnimation:true];
}

- (void) viewWillDisappear:(BOOL)animated{
	NSInteger index = [self.navigationController.viewControllers indexOfObject:self.navigationController.topViewController];
	if([[self.navigationController.viewControllers objectAtIndex:index] isKindOfClass:[RSSChannelTableViewController class]]){
		RSSChannelTableViewController *parent = (RSSChannelTableViewController *)[self.navigationController.viewControllers objectAtIndex:index];
		[parent update];
	}
	[super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channel.news.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	RSSTableViewCell *cell = (RSSTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell"
																				forIndexPath:indexPath];
	RSSNews *item = [self.channel.news objectAtIndex:indexPath.row];
	cell.data = item;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	_clickedItem = indexPath.row;
	[self performSegueWithIdentifier:@"RSSNewsDetailSegue" sender:tableView];
}

#pragma mark - RSSSourceDelegate

- (void)RSSSource:(RSSSource*)RSSSource didStartRefreshing:(NSURL *)url{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.refreshControl beginRefreshing];
	});
}

- (void)RSSSource:(RSSSource*)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		_channel = rssChannel;
		self.title = _channel.name;
		[self.refreshControl endRefreshing];
		[self.tableView reloadData];
	});
}

- (void)RSSSource:(RSSSource*)RSSSource didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.refreshControl endRefreshing];
		[self showError:err];
	});
}

@end
