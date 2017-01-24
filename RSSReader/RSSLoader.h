//
//  RSSLoader.h
//  RSSReader
//
//  Created by User on 11/22/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSLoaderDelegate.h"

@interface RSSLoader : NSObject

@property (nonatomic, weak) id <RSSLoaderDelegate> delegate;

+ (instancetype)loaderWithURL:(NSURL*)url;

- (instancetype)initWithURL:(NSURL*)url;
- (void)startLoading;

@end
