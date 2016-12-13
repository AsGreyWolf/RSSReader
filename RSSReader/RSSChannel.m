//
//  RSSChannel.m
//  RSSReader
//
//  Created by User on 11/29/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSChannel.h"
#import "RSSSource.h"

@interface RSSChannel (){
	RSSSource * _source;
}

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSArray<RSSNews *> * news;
@property (strong, nonatomic) NSURL * url;

@end

@implementation RSSChannel

- (instancetype) initWithName:(NSString*)name
					  withUrl:(NSURL*)url
				 withNewsList:(NSArray<RSSNews *>*)newsList{
	self = [self init];
	self.name = name;
	self.news = [newsList sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date"
																					  ascending:false]]];
	self.url = url;
	return self;
}
- (void) writeModel:(RSSChannelModel *)model{
	model.name = self.name;
	model.url = [self.url absoluteString];
	for(RSSNews *news in self.news){
		RSSNewsModel *dbNews = [NSEntityDescription insertNewObjectForEntityForName:@"RSSNewsModel"
															 inManagedObjectContext:model.managedObjectContext];
		[news writeModel:dbNews
			 withChannel:model];
	}
}

+ (instancetype) channelWithModel:(RSSChannelModel *)model{
	NSSet <RSSNewsModel*> *dbNewsList = model.news;
	NSMutableArray<RSSNews*> *newsList = [NSMutableArray new];
	for(RSSNewsModel * dbNews in dbNewsList)
		[newsList addObject:[RSSNews newsWithModel:dbNews]];
	RSSChannel * result = [RSSChannel channelWithName:model.name
											  withUrl:[NSURL URLWithString:model.url]
										 withNewsList:newsList];
	return result;
}
+ (instancetype) channelWithName:(NSString*)name
						 withUrl:(NSURL*)url
					withNewsList:(NSArray<RSSNews *>*)newsList{
	return [[RSSChannel alloc] initWithName:name
									withUrl:url
							   withNewsList:newsList];
}

@end
