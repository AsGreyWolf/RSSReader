//
//  RSSLoaderDelegate.h
//  RSSReader
//
//  Created by User on 11/24/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSLoader;

@protocol RSSLoaderDelegate <NSObject>

- (void)RSSLoader:(RSSLoader*)RSSLoader didStartLoading:(NSURL *)url;
- (void)RSSLoader:(RSSLoader*)RSSLoader didFinishLoading:(NSData *)data;
- (void)RSSLoader:(RSSLoader*)RSSLoader didFailWithError:(NSError *)err;

@end
