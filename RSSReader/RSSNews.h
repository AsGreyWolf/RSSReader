//
//  RSSNews.h
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSNews : NSObject

@property(readonly, atomic) NSString* _Nonnull title;
@property(readonly, atomic) NSDate* _Nullable date;
@property(readonly, atomic) NSString* _Nonnull text;
@property(readonly, atomic) NSURL* _Nullable url;
@property(readonly, atomic) NSString* _Nonnull guid;

-(id _Nonnull)initWithTitle:(NSString * _Nonnull) title
				   withDate:(NSDate * _Nullable) date
				   withText:(NSString * _Nonnull)text
					withURL:(NSURL * _Nullable)url
				   withGUID:(NSString * _Nonnull)guid;

+(id _Nonnull)newsWithTitle:(NSString * _Nonnull) title
				   withDate:(NSDate * _Nullable) date
				   withText:(NSString * _Nonnull) text
					withURL:(NSURL * _Nullable) url
				   withGUID:(NSString * _Nonnull)guid;

@end
