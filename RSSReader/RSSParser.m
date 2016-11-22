//
//  RSSParser.m
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSParser.h"


@implementation RSSParser

- (NSArray*)parse:(NSData*)data{
	_newsList = [NSMutableArray new];
	_stack = [NSMutableArray new];
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
	_dateFormatter2 = [[NSDateFormatter alloc] init];
	[_dateFormatter2 setDateFormat:@"dd MMM yyyy HH:mm:ss ZZ"];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	[parser parse];
	return _newsList;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict {
	[_stack addObject:[NSMutableString new]];
	if ([elementName isEqualToString:@"item"]) {
		title = @"";
		description = @"";
		date = nil;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	int top = [_stack count]-1;
	NSMutableString* str = [_stack objectAtIndex:top];
	[_stack removeLastObject];
	if ([elementName isEqualToString:@"item"]) {
		[_newsList addObject:[RSSNews newsWithTitle:title withDate:date withText:description]];
	} else if ([elementName isEqualToString:@"title"]) {
		title = str;
	} else if ([elementName isEqualToString:@"description"]) {
		description = str;
	} else if ([elementName isEqualToString:@"pubDate"]) {
		date = [_dateFormatter dateFromString:str];
		if(!date){
			date = [_dateFormatter2 dateFromString:str];
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	int top = [_stack count]-1;
	NSMutableString* str = [_stack objectAtIndex:top];
	[str appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	_newsList = nil;
}


@end
