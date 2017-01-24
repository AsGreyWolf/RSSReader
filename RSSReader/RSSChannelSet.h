//
//  RSSChannelSet.h
//  RSSReader
//
//  Created by User on 1/16/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSChannelSetDelegate.h"

@interface RSSChannelSet : NSObject

@property (nonatomic, weak) id <RSSChannelSetDelegate> delegate;
@property (nonatomic,readonly) NSArray<RSSChannel*> *channels;
@property (nonatomic,readonly) int unreadCount;

- (void)refresh;
- (void)addURL:(NSURL*) url;
- (void)removeChannel:(RSSChannel*) channel;

@end
