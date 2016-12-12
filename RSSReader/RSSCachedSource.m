//
//  RSSCachedSource.m
//  RSSReader
//
//  Created by User on 12/8/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSCachedSource.h"
#import "RSSUrlSource.h"
#import "NSManagedObjectContext+contextWithSqlite.h"
#import "RSSChannelModel+CoreDataClass.h"
#import "RSSNewsModel+CoreDataClass.h"
#import <CoreData/CoreData.h>

@interface RSSCachedSource () <RSSSourceDelegate>{
	RSSUrlSource * _urlSource;
}

- (void)loadCached;

@end

@implementation RSSCachedSource

- (void)loadCached{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
									initWithEntityName:@"RSSChannelModel"];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url like %@",[_urlSource.url absoluteString]];
	NSError *dbError;
	NSArray <RSSChannelModel*> *dbResult = [[NSManagedObjectContext contextWithSharedContext] executeFetchRequest:fetchRequest
																											error:&dbError];
	if(dbError!=nil){
		NSLog(@"%@",dbError);
		abort();
	}
	if(dbResult.count>0) {
		RSSChannelModel *dbChannel = [dbResult objectAtIndex:0];
		NSMutableSet <RSSNewsModel*> *dbNewsList = [dbChannel valueForKey:@"news"];
		NSMutableArray<RSSNews*> *newsList = [NSMutableArray new];
		for(RSSNewsModel * dbNews in dbNewsList){
			RSSNews * news = [RSSNews newsWithTitle:dbNews.title
										   withDate:dbNews.date
										   withText:dbNews.text
											withURL:[NSURL URLWithString:dbNews.url]
										   withGUID:dbNews.guid];
			[newsList addObject:news];
		}
		RSSChannel * channel = [RSSChannel channelWithName:dbChannel.name
												   withUrl:[NSURL URLWithString:dbChannel.url]
											  withNewsList:newsList];
		[self.delegate RSSSource:self
			 didFinishRefreshing:channel];
	}
}

- (void)RSSSource:(RSSSource*)RSSSource didStartRefreshing:(NSURL *)url{
	[self.delegate RSSSource:self
		  didStartRefreshing:url];
}

- (void)RSSSource:(RSSSource*)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	NSManagedObjectContext * context = [NSManagedObjectContext contextWithSharedContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url like %@",[rssChannel.url absoluteString]];
	NSError *dbError;
	NSArray <RSSChannelModel*> *dbResult = [context executeFetchRequest:fetchRequest
																  error:&dbError];
	if(dbError!=nil){
		NSLog(@"%@",dbError);
		abort();
	}
	for(RSSChannelModel *dbChannel in dbResult) {
		[context deleteObject:dbChannel];
	}
	RSSChannelModel *dbChannel = [NSEntityDescription insertNewObjectForEntityForName:@"RSSChannelModel"
															   inManagedObjectContext:context];
	dbChannel.name = rssChannel.name;
	dbChannel.url = [rssChannel.url absoluteString];
	for(RSSNews *news in rssChannel.news){
		RSSNewsModel *dbNews = [NSEntityDescription insertNewObjectForEntityForName:@"RSSNewsModel"
															 inManagedObjectContext:context];
		dbNews.title = news.title;
		dbNews.date = news.date;
		dbNews.text = news.text;
		dbNews.url = [news.url absoluteString];
		dbNews.guid = news.guid;
		dbNews.read = news.read;
		dbNews.channel = dbChannel;
	}
	if(![context save:&dbError]){
		NSLog(@"%@",dbError);
		abort();
	}
	if(![[NSManagedObjectContext mainContext] save:&dbError]){
		NSLog(@"%@",dbError);
		abort();
	}
	[self.delegate RSSSource:self
		 didFinishRefreshing:rssChannel];
}

- (void)RSSSource:(RSSSource*)RSSSource didFailWithError:(NSError *)err{
	[self.delegate RSSSource:self
			didFailWithError:err];
	[self loadCached];
}

- (void) refresh {
	[_urlSource refresh];
}

- (instancetype)initWithURL:(NSURL*)url{
	_urlSource = [RSSUrlSource sourceWithURL:url];
	_urlSource.delegate = self;
	return self;
}

+ (instancetype)sourceWithURL:(NSURL*)url{
	return [[RSSCachedSource alloc] initWithURL:url];
}

@end
