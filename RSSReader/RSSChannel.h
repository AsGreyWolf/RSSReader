//
//  RSSChannel.h
//  RSSReader
//
//  Created by User on 11/29/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSChannelModel+CoreDataClass.h"
#import "RSSNews.h"

@interface RSSChannel : NSObject

+ (instancetype) channelWithName:(NSString*)name withUrl:(NSURL*)url withImage:(NSURL*)image withNewsList:(NSArray<RSSNews *>*)newsList;

- (instancetype) initWithName:(NSString*)name withUrl:(NSURL*)url withImage:(NSURL*)image withNewsList:(NSArray<RSSNews *>*)newsList;

@property (readonly, nonatomic) NSString * name;
@property (readonly, nonatomic) NSURL * url;
@property (readonly, nonatomic) NSURL * image;
@property (readonly, nonatomic) NSArray<RSSNews *> * news;

@end
