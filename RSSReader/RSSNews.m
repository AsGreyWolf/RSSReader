//
//  RSSNews.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSNews.h"

@interface RSSNews()

@property(strong, atomic) NSString* _Nonnull title;
@property(strong, atomic) NSDate* _Nullable date;
@property(strong, atomic) NSString* _Nonnull text;
@property(strong, atomic) NSURL* _Nullable url;
@property(strong, atomic) NSString* _Nonnull guid;

@end


@implementation RSSNews

-(id _Nonnull)initWithTitle:(NSString * _Nonnull) title
				   withDate:(NSDate * _Nullable) date
				   withText:(NSString * _Nonnull) text
					withURL:(NSURL * _Nullable) url
				   withGUID:(NSString * _Nonnull)guid{
	RSSNews* result = [self init];
	result.title = title;
	result.date = date;
	result.text = text;
	result.url = url;
	result.guid = guid;
	return result;
}

+(id _Nonnull)newsWithTitle:(NSString * _Nonnull) title
				   withDate:(NSDate * _Nullable) date
				   withText:(NSString * _Nonnull) text
					withURL:(NSURL * _Nullable) url
				   withGUID:(NSString * _Nonnull)guid{
	return [[RSSNews alloc] initWithTitle:title withDate:date withText:text withURL:url withGUID:guid];
}

@end
