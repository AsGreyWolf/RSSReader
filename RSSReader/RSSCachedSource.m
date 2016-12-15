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

@interface RSSCachedSource () <RSSSourceDelegate>{
	RSSUrlSource * _urlSource;
	RSSDatabaseSource * _databaseSource;
}

@end

@implementation RSSCachedSource

- (void)RSSSource:(RSSSource*)RSSSource didStartRefreshing:(NSURL *)url{
	[self.delegate RSSSource:self
		  didStartRefreshing:url];
}

- (void)RSSSource:(RSSSource*)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel{
	if(RSSSource == _urlSource){
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
		[rssChannel writeModel:dbChannel];
		if(![context save:&dbError]){
			NSLog(@"%@",dbError);
			abort();
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			NSError *dbError;
			if(![[NSManagedObjectContext mainContext] save:&dbError]){
				NSLog(@"%@",dbError);
				abort();
			}
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

- (instancetype)initWithURL:(NSURL*)url{
	_urlSource = [RSSUrlSource sourceWithURL:url];
	_urlSource.delegate = self;
	_databaseSource = [RSSDatabaseSource sourceWithURL:url];
	_databaseSource.delegate = self;
	return self;
}

+ (instancetype)sourceWithURL:(NSURL*)url{
	return [[RSSCachedSource alloc] initWithURL:url];
}

@end
