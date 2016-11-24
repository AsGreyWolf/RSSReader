//
//  RSSNews.h
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSNews : NSObject

@property(readonly) NSString* _Nonnull title;
@property(readonly) NSDate* _Nullable date;
@property(readonly) NSString* _Nonnull text;
@property(readonly) NSURL* _Nullable url;

-(id _Nonnull)initWithTitle:(NSString * _Nonnull) title
			 withDate:(NSDate * _Nullable) date
			 withText:(NSString * _Nonnull)text
			 withURL:(NSURL * _Nullable)url;

+(id _Nonnull)newsWithTitle:(NSString * _Nonnull) title
		  withDate:(NSDate * _Nullable) date
		  withText:(NSString * _Nonnull) text
		  withURL:(NSURL * _Nullable) url;

@end
