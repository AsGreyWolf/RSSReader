//
//  RSSParser.m
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSParser.h"

@interface RSSParser ()

@property(readonly) NSArray* _Nonnull dateFormats;

@end


@implementation RSSParser

- (NSArray * _Nonnull) dateFormats{
	return @[@"EEE, dd MMM yyyy HH:mm:ss ZZ", @"dd MMM yyyy HH:mm:ss ZZ"];
}

- (NSArray* _Nullable)parse:(NSData* _Nonnull)data{
	_newsList = [NSMutableArray  new];
	_stack = [NSMutableArray new];
	_dateFormatter = [[NSDateFormatter alloc] init];
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
		url = nil;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	int top = [_stack count]-1;
	NSMutableString* str = [_stack objectAtIndex:top];
	[_stack removeLastObject];
	if ([elementName isEqualToString:@"item"]) {
		[_newsList addObject:[RSSNews newsWithTitle:title withDate:date withText:description withURL:url]];
	} else if ([elementName isEqualToString:@"title"]) {
		title = str;
	} else if ([elementName isEqualToString:@"description"]) {
		description = str;
	} else if ([elementName isEqualToString:@"pubDate"]) {
		NSArray *formats = self.dateFormats;
		for(int i=0; i<formats.count;i++){
			_dateFormatter.dateFormat = [formats objectAtIndex:i];
			date = [_dateFormatter dateFromString:str];
			if(date) break;
		}
	} else if ([elementName isEqualToString:@"link"]) {
		url = [NSURL URLWithString:str];
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
