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
	NSMutableArray *_newsList;
	NSMutableArray *_stack;
	NSString *title;
	NSString *description;
	NSDate *date;
	NSDateFormatter *_dateFormatter;
}

- (NSArray*)parse:(NSData*)data;

@end
