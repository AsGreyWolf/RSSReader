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

@interface RSSParser : NSObject<NSXMLParserDelegate>

- (RSSChannel* _Nullable)parse:(NSData* _Nonnull)data;

@end
