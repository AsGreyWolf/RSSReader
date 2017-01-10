//
//  RSSDatabaseSource.m
//  RSSReader
//
//  Created by User on 12/13/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSDatabaseSource.h"
#import "NSManagedObjectContext+contextWithSqlite.h"
#import <CoreData/CoreData.h>

@interface RSSDatabaseSource (){
	NSURL *_url;
}

@end


@implementation RSSDatabaseSource

- (void) refresh {
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSManagedObjectContext *context = [NSManagedObjectContext contextWithSharedContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]
										initWithEntityName:@"RSSChannelModel"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"url like %@",[_url absoluteString]];
		NSError *dbError;
		NSArray <RSSChannelModel*> *dbResult = [context executeFetchRequest:fetchRequest
																	  error:&dbError];
		NSAssert(dbError==nil, @"Database selection failed");
		if(dbResult.count>0) {
			RSSChannel *channel = [RSSChannel channelWithModel:[dbResult objectAtIndex:0]];
			[self.delegate RSSSource:self
				 didFinishRefreshing:channel];
		}
	});
}

- (instancetype)initWithURL:(NSURL*)url{
	self = [self init];
	_url = url;
	return self;
}

+ (instancetype)sourceWithURL:(NSURL*)url{
	return [[RSSDatabaseSource alloc] initWithURL:url];
}

@end
