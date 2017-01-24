//
//  RSSNews.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSNews.h"
#import "RSSNewsModel+CoreDataClass.h"
#import "NSManagedObjectContext+contextWithSqlite.h"

@interface RSSNews()

@property(strong, nonatomic) NSString* _Nonnull title;
@property(strong, nonatomic) NSDate* _Nullable date;
@property(strong, nonatomic) NSString* _Nonnull text;
@property(strong, nonatomic) NSURL* _Nullable url;
@property(strong, nonatomic) NSString* _Nonnull guid;
@property(nonatomic) bool read;

@end


@implementation RSSNews

+(instancetype _Nonnull)newsWithTitle:(NSString * _Nonnull) title
							 withDate:(NSDate * _Nullable) date
							 withText:(NSString * _Nonnull) text
							  withURL:(NSURL * _Nullable) url
							 withGUID:(NSString * _Nonnull)guid{
	return [[RSSNews alloc] initWithTitle:title withDate:date withText:text withURL:url withGUID:guid];
}

-(instancetype _Nonnull)initWithTitle:(NSString * _Nonnull) title
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

@end
