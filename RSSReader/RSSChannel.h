//
//  RSSChannel.h
//  RSSReader
//
//  Created by User on 11/29/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSNews.h"

@interface RSSChannel : NSObject

@property (readonly, nonatomic) NSString * name;
@property (readonly, nonatomic) NSArray<RSSNews *> * news;

- (instancetype) initWithName:(NSString*)name withNewsList:(NSArray<RSSNews *>*)newsList;

+ (instancetype) channelWithName:(NSString*)name withNewsList:(NSArray<RSSNews *>*)newsList;

@end
