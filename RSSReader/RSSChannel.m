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
@property (strong, nonatomic) NSArray * newsList;

@end

@implementation RSSChannel

- (id) initWithName:(NSString*)name withNewsList:(NSArray*)newsList{
	self = [self init];
	self.name = name;
	self.newsList = newsList;
	return self;
}

+ (id) channelWithName:(NSString*)name withNewsList:(NSArray*)newsList{
	return [[RSSChannel alloc] initWithName:name withNewsList:newsList];
}

@end
