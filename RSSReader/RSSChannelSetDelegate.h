//
//  RSSChannelSetDelegate.h
//  RSSReader
//
//  Created by User on 1/16/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSChannel.h"

@class RSSChannelSet;

@protocol RSSChannelSetDelegate <NSObject>

- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didStartRefreshing:(NSArray<RSSChannel*> *)rssChannel;
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFinishRefreshing:(NSArray<RSSChannel*> *)rssChannel;
- (void)RSSChannelSet:(RSSChannelSet*)RSSChannelSet didFailWithError:(NSError *)err;

@end
