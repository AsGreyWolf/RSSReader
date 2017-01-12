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

@interface RSSTableViewController () <RSSSourceDelegate>{
	UIBarButtonItem *_refreshButtonBarItem;
	UIBarButtonItem *_spinnerBarItem;
	UIActivityIndicatorView *_spinner;
	RSSSource *_rssSource;
	int _clickedItem;
}

- (void)showError:(NSError*)err;

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

	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:_spinner];
	_refreshButtonBarItem = self.navigationItem.rightBarButtonItem;

	_clickedItem = -1;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[_rssSource refresh];
}

- (IBAction)refreshButtonTapped:(id)sender {
	[_rssSource refresh];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([[segue identifier] hasPrefix:@"RSSNewsDetailSegue"]){
		RSSDetailViewController *controller = [segue destinationViewController];
		controller.news = [self.channel.news objectAtIndex:_clickedItem];
		_clickedItem = -1;
	}
}

- (IBAction)unwindFromDetail:(UIStoryboardSegue*)sender{
	[self.tableView reloadData];
}

- (void)showError:(NSError *)err{
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
																	message:NSLocalizedString(@"Can not load RSS", nil)
															 preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil)
														  style:UIAlertActionStyleDestructive
														handler:nil];
	[alert addAction:alertAction];
	[self presentViewController:alert animated:YES completion:nil];
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
		self.navigationItem.rightBarButtonItem = _spinnerBarItem;
		[_spinner startAnimating];
	});
}

- (void)RSSSource:(RSSSource*)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.navigationItem.rightBarButtonItem = _refreshButtonBarItem;
		_channel = rssChannel;
		self.title = _channel.name;
		[self.tableView reloadData];
		CGPoint p = self.tableView.contentOffset;
		p.y = -64; // FIXME: do smth less stupid
		[self.tableView setContentOffset:p animated:NO];
	});
}

- (void)RSSSource:(RSSSource*)RSSSource didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		self.navigationItem.rightBarButtonItem = _refreshButtonBarItem;
		[self showError:err];
		CGPoint p = self.tableView.contentOffset;
		p.y = -64; // FIXME: do smth less stupid
		[self.tableView setContentOffset:p animated:NO];
	});
}

@end
