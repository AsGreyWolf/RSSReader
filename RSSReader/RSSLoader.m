//
//  RSSLoader.m
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSLoader.h"

@interface RSSLoader (){
	NSURL* _url;
	NSURLSessionTask *_task;
}

@end


@implementation RSSLoader

- (void)startLoading{
	[self.delegate RSSLoader:self didStartLoading:_url];
	_task = [[NSURLSession sharedSession] dataTaskWithURL:_url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (data) {
			if(self.delegate){
				[self.delegate RSSLoader:self didFinishLoading:data];
			}
		}else{
			if(self.delegate){
				[self.delegate RSSLoader:self didFailWithError:error];
			}
		}
	}];
	[_task resume];
}

- (instancetype)initWithURL:(NSURL*)url{
	self = [self init];
	_url = url;
	return self;
}


+ (instancetype)loaderWithURL:(NSURL*)url{
	return [[RSSLoader alloc] initWithURL:url];
}

@end
