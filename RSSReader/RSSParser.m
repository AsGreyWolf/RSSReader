//
//  RSSParser.m
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSParser.h"

@interface RSSParser () <NSXMLParserDelegate> {
	NSString * _Nonnull _title;
	NSString * _Nonnull _description;
	NSDate * _Nullable _date;
	NSURL * _Nullable _url;
	NSString * _Nonnull _guid;
	NSMutableArray<RSSNews *>* _Nullable _newsList;
	NSString * _Nonnull _channelName;
	NSMutableArray<NSMutableString *> * _Nonnull _stack;
	NSDateFormatter * _Nonnull _dateFormatter;
}

@property(readonly,nonatomic) NSArray* _Nonnull dateFormats;

@end


@implementation RSSParser

- (NSArray * _Nonnull) dateFormats{
	return @[@"EEE, dd MMM yyyy HH:mm:ss ZZ", @"dd MMM yyyy HH:mm:ss ZZ"];
}

- (RSSChannel* _Nullable)parse:(NSData* _Nonnull)data withUrl:(NSURL*)url{
	_channelName = @"";
	_newsList = [NSMutableArray  new];
	_stack = [NSMutableArray new];
	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]];
	NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
	parser.delegate = self;
	[parser parse];
	if(!_newsList) return nil;
	return [RSSChannel channelWithName:_channelName
							   withUrl:url
						  withNewsList:_newsList];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict {
	[_stack addObject:[NSMutableString new]];
	if ([elementName isEqualToString:@"item"]) {
		_title = @"";
		_description = @"";
		_date = nil;
		_url = nil;
		_guid = @"";
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	int top = [_stack count]-1;
	NSMutableString* str = [_stack objectAtIndex:top];
	[_stack removeLastObject];
	if ([elementName isEqualToString:@"item"]) {
		[_newsList addObject:[RSSNews newsWithTitle:_title withDate:_date withText:_description withURL:_url withGUID:_guid]];
	} else if ([elementName isEqualToString:@"title"]) {
		_title = str;
		if(_stack.count == 2)
			_channelName = _title;
	} else if ([elementName isEqualToString:@"description"]) {
		_description = str;
	} else if ([elementName isEqualToString:@"pubDate"]) {
		NSArray *formats = self.dateFormats;
		for(int i=0; i<formats.count;i++){
			_dateFormatter.dateFormat = [formats objectAtIndex:i];
			_date = [_dateFormatter dateFromString:str];
			if(_date) break;
		}
	} else if ([elementName isEqualToString:@"link"]) {
		_url = [NSURL URLWithString:str];
	} else if ([elementName isEqualToString:@"guid"]) {
		_guid = str;
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
