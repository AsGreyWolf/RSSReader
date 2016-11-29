//
//  RSSSourceDelegate.h
//  RSSReader
//
//  Created by User on 11/28/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSChannel.h"

@protocol RSSSourceDelegate <NSObject>

- (void)RSSSource:(id)RSSSource didStartRefreshing:(NSURL *)url;
- (void)RSSSource:(id)RSSSource didFinishRefreshing:(RSSChannel *)rssChannel;
- (void)RSSSource:(id)RSSSource didFailWithError:(NSError *)err;

@end
