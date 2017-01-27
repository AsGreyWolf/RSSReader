//
//  RSSChannelSet.m
//  RSSReader
//
//  Created by User on 1/16/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "RSSChannelSet.h"
#import "RSSCachedSource.h"
#import "NSManagedObjectContext+contextWithSqlite.h"
#import "RSSModelUtils.h"

@interface RSSChannelSet() <RSSSourceDelegate>{
	NSMutableDictionary<NSURL*, RSSSource*> *_sources;
	NSMutableSet<RSSSource*> *_processing;
	RSSSource *_newSource;
}

@property(strong,nonatomic) NSMutableArray <RSSChannel*> *channels;

@end


@implementation RSSChannelSet

- (int)unreadCount{
	int result = 0;
	for(RSSChannel* channel in self.channels)
		result+=channel.unreadCount;
	return result;
}

- (void)updateChannels{
	_newSource = nil;
		NSManagedObjectContext *context = [NSManagedObjectContext createSecondaryContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
		NSError *dbError;
		NSArray <RSSChannelModel*> *dbChannels = [context executeFetchRequest:fetchRequest
																		error:&dbError];
		NSAssert(dbError==nil, @"Database selection failed");
		dbChannels = [dbChannels sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name"
																							 ascending:true],
															   [NSSortDescriptor sortDescriptorWithKey:@"url"
																							 ascending:true]]];
		NSMutableArray <RSSChannel*> *channels = [NSMutableArray new];
		NSURL *prevURL = nil;
		for(RSSChannelModel *dbChannel in dbChannels){
			int count = 0;
			for(RSSNewsModel *dbNews in dbChannel.news){
				if(!dbNews.read) count++;
			}
			RSSChannel *channel = [RSSModelUtils channelWithModel:dbChannel];
			if([channel.url isEqual:prevURL]) continue;
			prevURL = channel.url;
			[channels addObject:channel];
			if([_sources objectForKey:channel.url]==nil){
				RSSSource *src = [RSSCachedSource sourceWithURL:channel.url];
				src.delegate = self;
				[_sources setObject:src forKey:channel.url];
			}
		}
		self.channels = channels;
}

- (void)refresh{
	[self updateChannels];
	[self.delegate RSSChannelSet:self didPreloaded:self.channels];
	[self.delegate RSSChannelSet:self didStartRefreshing:self.channels];
	[_sources enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
		[_processing addObject:object];
		[object refresh];
	}];
	if(_processing.count == 0){
		[self updateChannels];
		[self.delegate RSSChannelSet:self didFinishRefreshing:self.channels];
	}
}

- (void)addURL:(NSURL*) url{
	if(url==nil){
		[self.delegate RSSChannelSet:self
					didFailWithError:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
														 code:43
													 userInfo:nil]];
		return;
	}
	RSSSource *src = [RSSCachedSource sourceWithURL:url];
	src.delegate = self;
	[_sources setObject:src forKey:url];
	[self refresh];
	_newSource = src;
}

- (void)removeChannel:(RSSChannel*) channel{
	[_sources removeObjectForKey:channel.url];
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSManagedObjectContext *context = [NSManagedObjectContext createSecondaryContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url like %@",[channel.url absoluteString]];
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
			[self refresh];
		});
	});
}

- (instancetype)init{
	self = [super init];
	_sources = [NSMutableDictionary new];
	_processing = [NSMutableSet new];
	return self;
}

#pragma mark - RSSSourceDelegate

- (void)RSSSource:(RSSSource *)RSSSource didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		if([_processing containsObject:RSSSource])
			[_processing removeObject:RSSSource];
		if(_newSource == RSSSource)
			[self.delegate RSSChannelSet:self
						didFailWithError:err];
		if(_processing.count == 0){
			[self updateChannels];
			[self.delegate RSSChannelSet:self didFinishRefreshing:self.channels];
		}
	});
}

- (void)RSSSource:(RSSSource *)RSSSource didStartRefreshing:(NSURL *)url{
}

- (void)RSSSource:(RSSSource *)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		if([_processing containsObject:RSSSource])
			[_processing removeObject:RSSSource];
		if(_processing.count == 0){
			[self updateChannels];
			[self.delegate RSSChannelSet:self didFinishRefreshing:self.channels];
		}
	});
}

@end
