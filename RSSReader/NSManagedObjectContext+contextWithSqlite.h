//
//  NSManagedObjectContext+NSManagedObjectContext_contextWithSqlite.h
//  RSSReader
//
//  Created by User on 12/9/16.
//  Copyright © 2016 User. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (contextWithSqlite)

+(instancetype)mainContext;
+(instancetype)contextWithSqlite:(NSString*)name;
+(instancetype)contextWithSharedContext;

@end
