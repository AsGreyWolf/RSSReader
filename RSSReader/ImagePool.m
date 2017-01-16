//
//  ImagePool.m
//  RSSReader
//
//  Created by User on 1/16/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "ImagePool.h"

@implementation ImagePool

+ (UIImage*)imageWithUrl:(NSURL*)url{
	static NSCache *imagesCache;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		imagesCache = [[NSCache alloc] init];
	});
	UIImage *result = [imagesCache objectForKey:url];
	if(result != nil) return result;
	result = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	if(result != nil)
		[imagesCache setObject:result forKey:url];
	return result;
}

@end
