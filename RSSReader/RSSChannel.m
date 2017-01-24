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
@property (strong, nonatomic) NSURL * image;

@end

@implementation RSSChannel

+ (instancetype) channelWithName:(NSString*)name
						 withUrl:(NSURL*)url
					   withImage:(NSURL*)image
					withNewsList:(NSArray<RSSNews *>*)newsList{
	return [[RSSChannel alloc] initWithName:name
									withUrl:url
								  withImage:image
							   withNewsList:newsList];
}

- (instancetype) initWithName:(NSString*)name
					  withUrl:(NSURL*)url
					withImage:(NSURL*)image
				 withNewsList:(NSArray<RSSNews *>*)newsList{
	self = [self init];
	self.name = name;
	self.news = [newsList sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date"
																					  ascending:false]]];
	self.url = url;
	self.image = image;
	return self;
}

- (int)unreadCount{
	int result=0;
	for(RSSNews *item in self.news)
		if(!item.read) result++;
	return result;
}

@end
