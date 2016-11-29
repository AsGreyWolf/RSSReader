//
//  RSSChannel.h
//  RSSReader
//
//  Created by User on 11/29/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSChannel : NSObject

@property (readonly, nonatomic) NSString * name;
@property (readonly, nonatomic) NSArray * newsList;

- (id) initWithName:(NSString*)name withNewsList:(NSArray*)newsList;

+ (id) channelWithName:(NSString*)name withNewsList:(NSArray*)newsList;

@end
