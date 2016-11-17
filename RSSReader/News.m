//
//  News.m
//  RSSReader
//
//  Created by User on 11/11/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "News.h"

@interface News()
@property NSString* title;
@property NSDate* date;
@property NSString* text;
@end

@implementation News
-(id)initWithTitle:(NSString *) title
			 withDate:(NSDate *) date
			 withText:(NSString *) text{
	News* result = [self init];
	result.title = title;
	result.date = date;
	result.text = text;
	return result;
}
+(id)newsWithTitle:(NSString *) title
	  withDate:(NSDate *) date
	  withText:(NSString *) text{
	return [[News alloc] initWithTitle:title withDate:date withText:text];
}
@end
