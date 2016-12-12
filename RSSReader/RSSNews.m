//
//  RSSNews.m
//  RSSReader
//
//  Created by User on 11/21/16.
//  Copyright © 2016 User. All rights reserved.
//

#import "RSSNews.h"
#import "RSSNewsModel+CoreDataClass.h"
#import "NSManagedObjectContext+contextWithSqlite.h"

@interface RSSNews()

@property(strong, atomic) NSString* _Nonnull title;
@property(strong, atomic) NSDate* _Nullable date;
@property(strong, atomic) NSString* _Nonnull text;
@property(strong, atomic) NSURL* _Nullable url;
@property(strong, atomic) NSString* _Nonnull guid;

@end


@implementation RSSNews

@synthesize read = _read;

-(void)setRead:(bool)read{
	_read = read;
	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSManagedObjectContext *context = [NSManagedObjectContext contextWithSharedContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSNewsModel"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"guid like %@",self.guid];
		NSError *dbError;
		NSArray <RSSNewsModel*> *dbResult = [context executeFetchRequest:fetchRequest
																   error:&dbError];
		if(dbError!=nil){
			NSLog(@"%@",dbError);
			abort();
		}
		for(RSSNewsModel *dbNews in dbResult)
			dbNews.read = read;
		if(![context save:&dbError]){
			NSLog(@"%@",dbError);
			abort();
		}
		if(![[NSManagedObjectContext mainContext] save:&dbError]){
			NSLog(@"%@",dbError);
			abort();
		}
	});
}
-(bool)read{
	return _read;
}
-(instancetype _Nonnull)initWithTitle:(NSString * _Nonnull) title
							 withDate:(NSDate * _Nullable) date
							 withText:(NSString * _Nonnull) text
							  withURL:(NSURL * _Nullable) url
							 withGUID:(NSString * _Nonnull)guid{
	RSSNews* result = [self init];
	result.title = title;
	result.date = date;
	result.text = text;
	result.url = url;
	result.guid = guid;
	dispatch_async(dispatch_get_main_queue(), ^{
		NSManagedObjectContext *context = [NSManagedObjectContext mainContext];
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSSNewsModel"];
		fetchRequest.predicate = [NSPredicate predicateWithFormat:@"guid like %@",self.guid];
		NSError *dbError;
		NSArray <RSSNewsModel*> *dbResult = [context executeFetchRequest:fetchRequest
																   error:&dbError];
		if(dbError!=nil){
			NSLog(@"%@",dbError);
			abort();
		}
		for(RSSNewsModel *dbNews in dbResult) {
			_read = dbNews.read;
			break;
		}
	});
	return result;
}

+(instancetype _Nonnull)newsWithTitle:(NSString * _Nonnull) title
							 withDate:(NSDate * _Nullable) date
							 withText:(NSString * _Nonnull) text
							  withURL:(NSURL * _Nullable) url
							 withGUID:(NSString * _Nonnull)guid{
	return [[RSSNews alloc] initWithTitle:title withDate:date withText:text withURL:url withGUID:guid];
}

@end
