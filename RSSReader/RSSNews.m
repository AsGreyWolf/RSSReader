//
//  RSSNews.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSNews.h"

@interface RSSNews()

@property NSString* title;
@property NSDate* date;
@property NSString* text;

@end


@implementation RSSNews

-(id)initWithTitle:(NSString *) title
			 withDate:(NSDate *) date
			 withText:(NSString *) text{
	RSSNews* result = [self init];
	result.title = title;
	result.date = date;
	result.text = text;
	return result;
}

+(id)newsWithTitle:(NSString *) title
		  withDate:(NSDate *) date
		  withText:(NSString *) text{
	return [[RSSNews alloc] initWithTitle:title withDate:date withText:text];
}

@end
