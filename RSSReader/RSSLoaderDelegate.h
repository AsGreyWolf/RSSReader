//
//  RSSLoaderDelegate.h
//  RSSReader
//
//  Created by User on 11/24/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSSLoaderDelegate <NSObject>

- (void)RSSLoader:(id)RSSLoader didStartLoading:(NSURL *)url;
- (void)RSSLoader:(id)RSSLoader didFinishLoading:(NSData *)data;
- (void)RSSLoader:(id)RSSLoader didFailWithError:(NSError *)err;

@end
