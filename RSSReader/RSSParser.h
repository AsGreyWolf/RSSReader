//
//  RSSParser.h
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "RSSNews.h"

@interface RSSParser <NSXMLParserDelegate> : NSObject

- (NSArray* _Nullable)parse:(NSData* _Nonnull)data;

@end
