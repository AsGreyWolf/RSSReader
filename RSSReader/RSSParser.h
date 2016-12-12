//
//  RSSParser.h
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSChannel.h"
#import "RSSNews.h"

@interface RSSParser : NSObject

- (RSSChannel* _Nullable)parse:(NSData* _Nonnull)data withUrl:(NSURL* _Nonnull)url;

@end
