//
//  MsgCache.m
//  objc-hubs-mask
//
//  Created by dev on 2022-04-28.
//  Copyright © 2022 Root Interface AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsgCache.h"

const NSTimeInterval kti_POLL_RES_SECONDS= 1;

@implementation EntryContext
@synthesize context= _id_Context;

+ (EntryContext*) contextWithSeconds:(NSTimeInterval)nsti_s_TTL {
	return [[self alloc] initContextWithSeconds:nsti_s_TTL];
}
+ (EntryContext*) context:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL {
	return [[self alloc] initContext:id_Context withSeconds:nsti_s_TTL];
}

//- (instancetype) init
//{
//	self = [super init];
//	if (self) {
//	}
//	return self;
//}

- (instancetype) initContextWithSeconds:(NSTimeInterval)nsti_s_TTL
{
	if ([self init]) {
		_id_Context= [NSNull null];
		_nsti_s_TTL= nsti_s_TTL;
		_nsdt_instant= [NSDate date];
	}
	return self;
}

- (instancetype) initContext:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL
{
	if ([self init]) {
		_id_Context= id_Context;
		_nsti_s_TTL= nsti_s_TTL;
		_nsdt_instant= [NSDate date];
	}
	return self;
}

- (BOOL) expired
{
	NSTimeInterval ti_since_now= [_nsdt_instant timeIntervalSinceNow]; //  produces a negative time interval
	if ((-ti_since_now) > _nsti_s_TTL)
		return TRUE;
	
	return FALSE;
}

@end


@implementation MsgCache

- (instancetype) init {
	self = [self initWithSeconds:kti_POLL_RES_SECONDS];
	if (self) {
	}
	return self;	
}

- (instancetype) initWithSeconds:(NSTimeInterval)ti_poll_res_seconds
{
	self = [super init];
	if (self) {
		_nsmdic_Cache= [[NSMutableDictionary alloc] init];
		_timer= [NSTimer scheduledTimerWithTimeInterval:ti_poll_res_seconds target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	}
	return self;
}

- (void) timerFireMethod:(NSTimer *)timer
{
	NSMutableDictionary* nsmdic_New= [[NSMutableDictionary alloc] init];
	
	[_nsmdic_Cache enumerateKeysAndObjectsUsingBlock: ^(NSString* nsstr_Entry, EntryContext* entryContext, BOOL *stop) {
		if (! [entryContext expired])
			[nsmdic_New setObject:entryContext forKey:nsstr_Entry];
		
		else NSLog(@"timerFire: *REMOVED [%@][%@]", nsstr_Entry, entryContext.context);
	}];
	
	_nsmdic_Cache= nsmdic_New;
}

- (void) cacheEntry:(NSString*)nsstr_Entry withContext:(EntryContext*)entryContext {
	[_nsmdic_Cache setObject:entryContext forKey:nsstr_Entry];
}

- (BOOL) contains:(NSString*)nsstr_Entry {
	EntryContext* entryContext;
	return [self contains:nsstr_Entry context:&entryContext];
}

- (BOOL) contains:(NSString*)nsstr_Entry context:(EntryContext**)p_entryContext {
	*p_entryContext= [_nsmdic_Cache objectForKey:nsstr_Entry];
	return (*p_entryContext != nil);
}

- (void) expire:(NSString*)nsstr_Entry {
	[_nsmdic_Cache removeObjectForKey:nsstr_Entry];
}

- (NSEnumerator*) entryEnumerator {
	return [_nsmdic_Cache keyEnumerator];
}

@end

