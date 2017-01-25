//
//  BackgroundRefresher.h
//  RSSReader
//
//  Created by User on 1/25/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackgroundRefresher : NSObject

+ (instancetype)refresherWithCompletionHandler:(void (^)(UIBackgroundFetchResult))handler;

- (instancetype)initWithCompletionHandler:(void (^)(UIBackgroundFetchResult))handler;

- (void)refresh;

@end
