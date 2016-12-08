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
#import "RSSSource.h"

@interface RSSTableViewController () <RSSSourceDelegate>{
	UIActivityIndicatorView *_spinner;
	RSSSource *_rssSource;
	int _clickedItem;
}

- (void)showError:(NSError*)err;

@end


@implementation RSSTableViewController

-(void)setChannel:(RSSChannel *)channel{
	_channel = channel;
	self.title = channel.name;
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UINib *cellNib = [UINib nibWithNibName:@"RSSTableViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"NewsCell"];

	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_spinner.center = CGPointMake(160, 240);
	_clickedItem = -1;
	_rssSource = [RSSSource sourceWithURL:[NSURL URLWithString:@"http://news.yandex.ru/hardware.rss"]];
	_rssSource.delegate = self;
	[_rssSource refresh];
}

- (IBAction)refreshButtonTapped:(id)sender {
	[_rssSource refresh];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([[segue identifier] hasPrefix:@"RSSNewsDetailSegue"]){
		RSSDetailViewController *controller = [segue destinationViewController];
		controller.news = [self.channel.newsList objectAtIndex:_clickedItem];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channel.newsList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	RSSTableViewCell *cell = (RSSTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
	RSSNews *item = [self.channel.newsList objectAtIndex:indexPath.row];
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

- (void)RSSSource:(id)RSSSource didStartRefreshing:(NSURL *)url{
	[self.tableView setContentOffset:CGPointZero animated:NO];
	[self.view addSubview:_spinner];
	[_spinner startAnimating];
}

- (void)RSSSource:(id)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	[self.view addSubview:_spinner];
	[_spinner removeFromSuperview];
	self.channel = rssChannel;
}

- (void)RSSSource:(id)RSSSource didFailWithError:(NSError *)err{
	[_spinner removeFromSuperview];
	[self showError:err];
}

@end
