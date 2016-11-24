//
//  RSSNews.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSNews.h"

@interface RSSNews()

@property NSString* _Nonnull title;
@property NSDate* _Nullable date;
@property NSString* _Nonnull text;
@property NSURL* _Nullable url;

@end


@implementation RSSNews

-(id _Nonnull)initWithTitle:(NSString * _Nonnull) title
			 withDate:(NSDate * _Nullable) date
			 withText:(NSString * _Nonnull) text
			 withURL:(NSURL * _Nullable) url{
	RSSNews* result = [self init];
	result.title = title;
	result.date = date;
	result.text = text;
	result.url = url;
	return result;
}

+(id _Nonnull)newsWithTitle:(NSString * _Nonnull) title
		  withDate:(NSDate * _Nullable) date
		  withText:(NSString * _Nonnull) text
		  withURL:(NSURL * _Nullable) url{
	return [[RSSNews alloc] initWithTitle:title withDate:date withText:text withURL:url];
}

@end
