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

@end

@implementation RSSChannel

- (instancetype) initWithName:(NSString*)name withNewsList:(NSArray<RSSNews *>*)newsList{
	self = [self init];
	self.name = name;
	self.news = newsList;
	return self;
}

+ (instancetype) channelWithName:(NSString*)name withNewsList:(NSArray<RSSNews *>*)newsList{
	return [[RSSChannel alloc] initWithName:name withNewsList:newsList];
}

@end
