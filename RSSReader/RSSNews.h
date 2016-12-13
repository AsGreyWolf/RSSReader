//
//  RSSNews.h
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSNewsModel+CoreDataClass.h"

@interface RSSNews : NSObject

@property(readonly, atomic) NSString* _Nonnull title;
@property(readonly, atomic) NSDate* _Nullable date;
@property(readonly, atomic) NSString* _Nonnull text;
@property(readonly, atomic) NSURL* _Nullable url;
@property(readonly, atomic) NSString* _Nonnull guid;
@property(atomic) bool read;

-(void)writeModel:(RSSNewsModel * _Nonnull)model withChannel:(RSSChannelModel * _Nonnull)channel;
-(instancetype _Nonnull)initWithTitle:(NSString * _Nonnull) title
							 withDate:(NSDate * _Nullable) date
							 withText:(NSString * _Nonnull)text
							  withURL:(NSURL * _Nullable)url
							 withGUID:(NSString * _Nonnull)guid;

+(instancetype _Nonnull)newsWithModel:(RSSNewsModel * _Nonnull)model;
+(instancetype _Nonnull)newsWithTitle:(NSString * _Nonnull) title
							 withDate:(NSDate * _Nullable) date
							 withText:(NSString * _Nonnull) text
							  withURL:(NSURL * _Nullable) url
							 withGUID:(NSString * _Nonnull)guid;

@end
