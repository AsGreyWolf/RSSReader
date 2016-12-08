//
//  RSSSourceDelegate.h
//  RSSReader
//
//  Created by User on 11/28/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSChannel.h"

@class RSSSource;

@protocol RSSSourceDelegate <NSObject>

- (void)RSSSource:(RSSSource*)RSSSource didStartRefreshing:(NSURL *)url;
- (void)RSSSource:(RSSSource*)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel;
- (void)RSSSource:(RSSSource*)RSSSource didFailWithError:(NSError *)err;

@end
