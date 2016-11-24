//
//  RSSParser.h
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "RSSNews.h"

@interface RSSParser <NSXMLParserDelegate> : NSObject{
	NSMutableArray * _Nullable _newsList;
	NSMutableArray * _Nonnull _stack;
	NSString * _Nonnull title;
	NSString * _Nonnull description;
	NSDate * _Nullable date;
	NSURL * _Nullable url;
	NSDateFormatter * _Nonnull _dateFormatter;
}

- (NSArray* _Nullable)parse:(NSData* _Nonnull)data;

@end
