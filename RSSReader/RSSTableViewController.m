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
#import "RSSParser.h"

@interface RSSTableViewController (){
	UIActivityIndicatorView *_spinner;
	RSSLoader *_rssLoader;
	RSSParser *_rssParser;
	int _clickedItem;
}

@end


@implementation RSSTableViewController

-(void)setNewsList:(NSArray *)newsList{
	_newsList = newsList;
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UINib *cellNib = [UINib nibWithNibName:@"RSSTableViewCell" bundle:nil];
	[self.tableView registerNib:cellNib forCellReuseIdentifier:@"NewsCell"];
	self.newsList = @[];

	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_spinner.center = CGPointMake(160, 240);
	[self.view addSubview:_spinner];
	_clickedItem = -1;
	_rssParser = [RSSParser new];
	_rssLoader = [RSSLoader loaderWithURL:[NSURL URLWithString:@"http://news.yandex.ru/hardware.rss"]];
	_rssLoader.delegate = self;
	[_rssLoader startLoading];
}

- (IBAction)refreshButtonTapped:(id)sender {
	[_rssLoader startLoading];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([[segue identifier] hasPrefix:@"RSSNewsDetailSegue"]){
		RSSDetailViewController *controller = [segue destinationViewController];
		controller.news = [self.newsList objectAtIndex:_clickedItem];
		_clickedItem = -1;
	}
}

- (IBAction)unwindFromDetail:(UIStoryboardSegue*)sender{}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	RSSTableViewCell *cell = (RSSTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
	RSSNews *item = [self.newsList objectAtIndex:indexPath.row];
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

#pragma mark - RSSLoaderDelegate

- (void)RSSLoader:(id)RSSLoader didStartLoading:(NSURL *)url{
	[_spinner startAnimating];
}

- (void)RSSLoader:(id)RSSLoader didFinishLoading:(NSData *)data{
	NSArray *parsed =  [_rssParser parse:data];
	[_spinner removeFromSuperview];
	self.newsList = parsed;
}

- (void)RSSLoader:(id)RSSLoader didFailWithError:(NSError *)err{
	NSLog(@"%@", err);
}

@end
