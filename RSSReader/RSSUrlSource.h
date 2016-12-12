//
//  RSSUrlSource.h
//  RSSReader
//
//  Created by User on 12/8/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSSource.h"

@interface RSSUrlSource : RSSSource

@property (strong,nonatomic) NSURL * url;

- (instancetype)initWithURL:(NSURL*)url;

+ (instancetype)sourceWithURL:(NSURL*)url;

@end
