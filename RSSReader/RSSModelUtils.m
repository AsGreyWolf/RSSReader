//
//  RSSModelUtils.m
//  RSSReader
//
//  Created by User on 1/24/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "RSSModelUtils.h"
#import "NSManagedObjectContext+contextWithSqlite.h"

@interface RSSNews()

@property(strong, nonatomic) NSString* _Nonnull title;
@property(strong, nonatomic) NSDate* _Nullable date;
@property(strong, nonatomic) NSString* _Nonnull text;
@property(strong, nonatomic) NSURL* _Nullable url;
@property(strong, nonatomic) NSString* _Nonnull guid;
@property(nonatomic) bool read;

@end

@implementation RSSModelUtils

+ (void)writeNewsModel:(RSSNewsModel * _Nonnull)model
			  withNews:(RSSNews * _Nonnull)news
		   withChannel:(RSSChannelModel * _Nonnull)channel{
	[RSSModelUtils getRead:news];
	model.title = news.title;
	model.date = news.date;
	model.text = news.text;
	model.url = [news.url absoluteString];
	model.guid = news.guid;
	model.read = news.read;
	model.channel = channel;
}
+ (RSSNews * _Nonnull)newsWithModel:(RSSNewsModel * _Nonnull)model{
	RSSNews * result = [RSSNews newsWithTitle:model.title
									 withDate:model.date
									 withText:model.text
									  withURL:[NSURL URLWithString:model.url]
									 withGUID:model.guid];
	[RSSModelUtils getRead:result];
	return result;
}
+ (void)setRead:(bool)read withNews:(RSSNews * _Nonnull)news{
	news.read = read;
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSManagedObjectContext *context = [NSManagedObjectContext createSecondaryContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSNewsModel"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"guid like %@",news.guid];
		NSError *dbError;
		NSArray <RSSNewsModel*> *dbResult = [context executeFetchRequest:fetchRequest
																   error:&dbError];
		NSAssert(dbError==nil, @"Database selection failed");
		for(RSSNewsModel *dbNews in dbResult)
			dbNews.read = read;
		[context save:&dbError];
		NSAssert(dbError==nil, @"Database save failed");
		dispatch_async(dispatch_get_main_queue(), ^{
			NSError *dbError;
			[[NSManagedObjectContext mainContext] save:&dbError];
			NSAssert(dbError==nil, @"Database save failed");
		});
	});
}
+ (bool)getRead:(RSSNews * _Nonnull)news{
	NSManagedObjectContext *context = [NSManagedObjectContext createSecondaryContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSNewsModel"];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"guid like %@",news.guid];
	NSError *dbError;
	NSArray <RSSNewsModel*> *dbResult = [context executeFetchRequest:fetchRequest
															   error:&dbError];
	NSAssert(dbError==nil, @"Database selection failed");
	for(RSSNewsModel *dbNews in dbResult) {
		news.read = dbNews.read;
		break;
	}
	return news.read;
}

+ (void)writeChannelModel:(RSSChannelModel * _Nonnull)model
			  withChannel:(RSSChannel * _Nonnull)channel{
	model.name = channel.name;
	model.url = [channel.url absoluteString];
	model.image = [channel.image absoluteString];
	for(RSSNews *news in channel.news){
		RSSNewsModel *dbNews = [NSEntityDescription insertNewObjectForEntityForName:@"RSSNewsModel"
															 inManagedObjectContext:model.managedObjectContext];
		[RSSModelUtils writeNewsModel:dbNews
							 withNews:news
						  withChannel:model];
	}
}
+ (RSSChannel * _Nonnull)channelWithModel:(RSSChannelModel * _Nonnull)model{
	NSSet <RSSNewsModel*> *dbNewsList = model.news;
	NSMutableArray<RSSNews*> *newsList = [NSMutableArray new];
	for(RSSNewsModel * dbNews in dbNewsList)
		[newsList addObject:[RSSModelUtils newsWithModel:dbNews]];
	RSSChannel * result = [RSSChannel channelWithName:model.name
											  withUrl:[NSURL URLWithString:model.url]
											withImage:[NSURL URLWithString:model.image]
										 withNewsList:newsList];
	return result;
}

@end
