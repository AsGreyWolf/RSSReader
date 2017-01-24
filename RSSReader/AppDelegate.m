//
//  AppDelegate.m
//  RSSReader
//
//  Created by User on 11/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "RSSChannelSet.h"

@interface AppDelegate() <RSSChannelSetDelegate>{
	void (^fetchCompletionHandler)(UIBackgroundFetchResult);
	RSSChannelSet *channelSet;
	int startUnreadCount;
}

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
	[application registerUserNotificationSettings:settings];
	[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
	return YES;
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
	fetchCompletionHandler = completionHandler;
	channelSet = [RSSChannelSet new];
	channelSet.delegate = self;
	[channelSet refresh];
}

#pragma mark - RSSChannelSetDelegate

- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didStartRefreshing:(NSArray<RSSChannel*> *)rssChannel{
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didPreloaded:(NSArray<RSSChannel*> *)rssChannel{
	startUnreadCount = [RSSChannelSet unreadCount];
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFinishRefreshing:(NSArray<RSSChannel*> *)rssChannel{
	dispatch_async(dispatch_get_main_queue(), ^{
		int unreadCount = RSSChannelSet.unreadCount;
		if(unreadCount > startUnreadCount)
			fetchCompletionHandler(UIBackgroundFetchResultNewData);
		else
			fetchCompletionHandler(UIBackgroundFetchResultNoData);
		UIApplication.sharedApplication.applicationIconBadgeNumber=unreadCount;
	});
}
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		fetchCompletionHandler(UIBackgroundFetchResultFailed);
	});
}

@end
