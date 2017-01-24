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

+ (instancetype)sourceWithURL:(NSURL*)url;

- (instancetype)initWithURL:(NSURL*)url;

@property (strong,nonatomic) NSURL * url;

@end
