//
//  BackgroundRefresher.m
//  RSSReader
//
//  Created by User on 1/25/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "BackgroundRefresher.h"
#import "RSSChannelSet.h"

@interface BackgroundRefresher() <RSSChannelSetDelegate>{
	void (^_completionHandler)(UIBackgroundFetchResult);
	RSSChannelSet *_channelSet;
	int _startUnreadCount;
}

@end

@implementation BackgroundRefresher

+ (instancetype)refresherWithCompletionHandler:(void (^)(UIBackgroundFetchResult))handler{
	return [[BackgroundRefresher alloc] initWithCompletionHandler:handler];
}

- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult))handler{
	self = [super init];
	_completionHandler = handler;
	_channelSet = [RSSChannelSet new];
	_channelSet.delegate = self;
	return self;
}

- (void)refresh{
	[_channelSet refresh];
}


#pragma mark - RSSChannelSetDelegate

- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didStartRefreshing:(NSArray<RSSChannel*> *)rssChannel{
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didPreloaded:(NSArray<RSSChannel*> *)rssChannel{
	_startUnreadCount = [RSSChannelSet unreadCount];
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFinishRefreshing:(NSArray<RSSChannel*> *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		int unreadCount = RSSChannelSet.unreadCount;
		if(unreadCount > _startUnreadCount)
			_completionHandler(UIBackgroundFetchResultNewData);
		else
			_completionHandler(UIBackgroundFetchResultNoData);
		UIApplication.sharedApplication.applicationIconBadgeNumber=unreadCount;
	});
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		_completionHandler(UIBackgroundFetchResultFailed);
	});
}

@end
