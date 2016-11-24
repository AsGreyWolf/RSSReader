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
	RSSLoader *_rssLoader;
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

	_rssLoader = [RSSLoader loaderWithURL:[NSURL URLWithString:@"http://news.yandex.ru/hardware.rss"]];
	_rssLoader.delegate = self;
	[_rssLoader startLoading];
}

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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if([[segue identifier] hasPrefix:@"RSSNewsDetailSegue"]){
		RSSDetailViewController *controller = [segue destinationViewController];
		controller.news = [self.newsList objectAtIndex:_clickedItem];
		_clickedItem = -1;
	}
}

- (IBAction)unwindFromDetail:(UIStoryboardSegue*)sender{}

- (void)RSSLoader:(id)RSSLoader didFinishLoading:(NSData *)data{
	RSSParser *parser = [RSSParser new];
	self.newsList = [parser parse:data];
}
- (void)RSSLoader:(id)RSSLoader didFailWithError:(NSError *)err{
	NSLog(@"%@", err);
}

@end
