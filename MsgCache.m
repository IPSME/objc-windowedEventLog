//
//  MsgCache.m
//  objc-hubs-mask
//
//  Created by dev on 2022-04-28.
//  Copyright © 2022 Root Interface AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgCache.h"

@implementation EntryContext
@synthesize context= _id_Context;

- (id) init
{
	self = [super init];
	if (self) {
	}
	return self;
}

- (id) initContextWithSeconds:(NSTimeInterval)nsti_s_TTL
{
	self= [self init];
	if (self) {
		_id_Context= [NSNull null];
		_nsti_s_TTL= nsti_s_TTL;
		_nsdt_instant= [NSDate date];
	}
	return self;
}

- (id) initContext:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL
{
	self= [self init];
	if (self) {
		_id_Context= id_Context;
		_nsti_s_TTL= nsti_s_TTL;
		_nsdt_instant= [NSDate date];
	}
	return self;
}

+ (EntryContext*) contextWithSeconds:(NSTimeInterval)nsti_s_TTL {
	return [[EntryContext alloc] initContextWithSeconds:nsti_s_TTL];
}
+ (EntryContext*) context:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL {
	return [[EntryContext alloc] initContext:id_Context withSeconds:nsti_s_TTL];
}

@end


@implementation MsgCache

- (id) init {
	self = [super init];
	if (self)
	{
		_nsmdic_Cache= [[NSMutableDictionary alloc] init];
		
	}
	return self;	
}

//- (id) initWithMilliseconds:(NSNumber*)poll_res_milliseconds
//{
//	
//}

- (void) cacheEntry:(NSString*)nsstr_Entry withContext:(EntryContext*)entryContext {
	[_nsmdic_Cache setObject:entryContext forKey:nsstr_Entry];
}

- (BOOL) contains:(NSString*)nsstr_Entry context:(EntryContext**)entryContext {
	*entryContext= [_nsmdic_Cache objectForKey:nsstr_Entry];
	return (*entryContext != nil);
}

- (void) expire:(NSString*)nsstr_Entry {
	[_nsmdic_Cache removeObjectForKey:nsstr_Entry];
}

@end

