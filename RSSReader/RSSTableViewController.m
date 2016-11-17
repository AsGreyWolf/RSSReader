//
//  RSSTableViewController.m
//  RSSReader
//
//  Created by User on 11/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSTableViewController.h"
#import "News.h"
#import "NewsTableViewCell.h"

@interface RSSTableViewController ()

@end

@implementation RSSTableViewController

-(void)setNewsList:(NSArray *)newsList{
	_newsList = newsList;
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.newsList = @[[News newsWithTitle:@"title 1" withDate:[NSDate dateWithTimeIntervalSinceNow:0] withText:@"text 1"],
			 [News newsWithTitle:@"title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2title 2" withDate:[NSDate dateWithTimeIntervalSinceNow:0] withText:@"text2text2text2text2text2text2text2text2text2text2text2\nline\nline\nline\nline"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	NewsTableViewCell *cell = (NewsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
	News *item = [self.newsList objectAtIndex:indexPath.row];
	cell.data = item;
	return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

@end
