//
//  RSSSource.m
//  RSSReader
//
//  Created by User on 11/28/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSSource.h"
#import "RSSLoader.h"
#import "RSSParser.h"

@interface RSSSource () <RSSLoaderDelegate>{
	NSURL *_url;
	RSSParser *_parser;
	RSSLoader *_loader;
}

@end


@implementation RSSSource

- (void)RSSLoader:(id)RSSLoader didStartLoading:(NSURL *)url{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.delegate RSSSource:self didStartRefreshing:url];
	});
}

- (void)RSSLoader:(id)RSSLoader didFinishLoading:(NSData *)data{
	RSSChannel * channel = [_parser parse:data];
	dispatch_async(dispatch_get_main_queue(), ^{
		if (!channel)
			[self.delegate RSSSource:self didFailWithError:[NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier]
																			   code:42
																		   userInfo:nil]];
		else
			[self.delegate RSSSource:self didFinishRefreshing:channel];
	});
}

- (void)RSSLoader:(id)RSSLoader didFailWithError:(NSError *)err{
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.delegate RSSSource:self didFailWithError:err];
	});
}

- (void)refresh{
	[_loader startLoading];
}

- (instancetype)initWithURL:(NSURL*)url{
	self = [self init];
	_url = url;
	_loader = [RSSLoader loaderWithURL:url];
	_loader.delegate = self;
	_parser = [RSSParser new];
	return self;
}

+ (instancetype)sourceWithURL:(NSURL*)url{
	return [[RSSSource alloc] initWithURL:url];
}

@end
