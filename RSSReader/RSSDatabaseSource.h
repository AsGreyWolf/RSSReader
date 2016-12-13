//
//  RSSDatabaseSource.h
//  RSSReader
//
//  Created by User on 12/13/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSSource.h"

@interface RSSDatabaseSource : RSSSource

- (instancetype)initWithURL:(NSURL*)url;

+ (instancetype)sourceWithURL:(NSURL*)url;

@end
