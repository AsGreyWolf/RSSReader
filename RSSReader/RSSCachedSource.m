//
//  RSSCachedSource.m
//  RSSReader
//
//  Created by User on 12/8/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSCachedSource.h"
#import "RSSUrlSource.h"
#import "RSSDatabaseSource.h"
#import "NSManagedObjectContext+contextWithSqlite.h"
#import <CoreData/CoreData.h>
#import "RSSModelUtils.h"

@interface RSSCachedSource () <RSSSourceDelegate>{
	RSSUrlSource * _urlSource;
	RSSDatabaseSource * _databaseSource;
}

@end

@implementation RSSCachedSource

+ (instancetype)sourceWithURL:(NSURL*)url{
	return [[RSSCachedSource alloc] initWithURL:url];
}

- (instancetype)initWithURL:(NSURL*)url{
	_urlSource = [RSSUrlSource sourceWithURL:url];
	_urlSource.delegate = self;
	_databaseSource = [RSSDatabaseSource sourceWithURL:url];
	_databaseSource.delegate = self;
	return self;
}

- (void)RSSSource:(RSSSource*)RSSSource didStartRefreshing:(NSURL *)url{
	[self.delegate RSSSource:self
		  didStartRefreshing:url];
}

- (void)RSSSource:(RSSSource*)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	if(RSSSource == _urlSource){
		NSManagedObjectContext * context = [NSManagedObjectContext createSecondaryContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSChannelModel"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url like %@",[rssChannel.url absoluteString]];
		NSError *dbError;
		NSArray <RSSChannelModel*> *dbResult = [context executeFetchRequest:fetchRequest
																	  error:&dbError];
		NSAssert(dbError==nil, @"Database selection failed");
		for(RSSChannelModel *dbChannel in dbResult) {
			[context deleteObject:dbChannel];
		}
		RSSChannelModel *dbChannel = [NSEntityDescription insertNewObjectForEntityForName:@"RSSChannelModel"
																   inManagedObjectContext:context];
		[RSSModelUtils writeChannelModel:dbChannel withChannel:rssChannel];
		[context save:&dbError];
		NSAssert(dbError==nil, @"Database save failed");
		dispatch_async(dispatch_get_main_queue(), ^{
			NSError *dbError;
			[[NSManagedObjectContext mainContext] save:&dbError];
			NSAssert(dbError==nil, @"Database save failed");
		});
	}
	[self.delegate RSSSource:self
		 didFinishRefreshing:rssChannel];
}

- (void)RSSSource:(RSSSource*)RSSSource didFailWithError:(NSError *)err{
	[self.delegate RSSSource:self
			didFailWithError:err];
	[_databaseSource refresh];
}

- (void) refresh {
	[_urlSource refresh];
}

@end
