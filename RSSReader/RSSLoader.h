//
//  RSSLoader.h
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RSSLoaderDelegate <NSObject>
- (void)RSSLoader:(id)RSSLoader didFinishLoading:(NSData *)data;
- (void)RSSLoader:(id)RSSLoader didFailWithError:(NSError *)err;
@end

@interface RSSLoader : NSObject{
	NSURL* _url;
	NSURLSessionTask *_task;
}

@property (nonatomic, weak) id <RSSLoaderDelegate> delegate;

- (void)startLoading;
- (id)initWithURL:(NSURL*)url;

+ (id)loaderWithURL:(NSURL*)url;

@end