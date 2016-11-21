//
//  RSSNews.h
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSNews : NSObject

@property(readonly) NSString* title;
@property(readonly) NSDate* date;
@property(readonly) NSString* text;

-(id)initWithTitle:(NSString *) title
			 withDate:(NSDate *) date
			 withText:(NSString *)text;

+(id)newsWithTitle:(NSString *) title
		  withDate:(NSDate *) date
		  withText:(NSString *) text;

@end
