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
const NSTimeInterval knsti_ENTRY_EXP_NEVER= -1;

@interface Context : NSObject
{
	NSTimeInterval _nsti_s_TTL;
	NSDate* _nsdt_instant;
}

@property id entry;
@property NSDictionary* userInfo;

+ (Context*) contextWithEntry:(id)id_entry userInfo:(NSDictionary*)nsdic_userInfo andSeconds:(NSTimeInterval)nsti_s_TTL;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initContextWithEntry:(id)id_entry userInfo:(NSDictionary*)nsdic_userInfo andSeconds:(NSTimeInterval)nsti_s_TTL;

- (bool) expired;

@end

//----------------------------------------------------------------------------------------------------------------

@implementation Context
@synthesize entry= _id_entry;
@synthesize userInfo= _id_userInfo;

+ (Context*) contextWithEntry:(id)id_entry userInfo:(NSDictionary*)nsdic_userInfo andSeconds:(NSTimeInterval)nsti_s_TTL {
	return [[self alloc] initContextWithEntry:id_entry userInfo:nsdic_userInfo andSeconds:nsti_s_TTL];
}

//- (instancetype) init
//{
//	self = [super init];
//	if (self) {
//	}
//	return self;
//}

- (instancetype) initContextWithEntry:(id)id_entry userInfo:(NSDictionary*)nsdic_userInfo andSeconds:(NSTimeInterval)nsti_s_TTL
{
	if ([self init]) {
		_id_entry= id_entry;
		_id_userInfo= nsdic_userInfo;
		_nsti_s_TTL= nsti_s_TTL;
		_nsdt_instant= [NSDate date];
	}
	return self;
}

- (bool) expired
{
	if (_nsti_s_TTL == knsti_ENTRY_EXP_NEVER)
		return false;

	NSTimeInterval ti_since_now= [_nsdt_instant timeIntervalSinceNow]; //  produces a negative time interval
	if ((-ti_since_now) > _nsti_s_TTL)
		return true;
	
	return false;
}

@end

//----------------------------------------------------------------------------------------------------------------

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
		_nsmarr_db= [[NSMutableArray alloc] init];
		_timer= [NSTimer scheduledTimerWithTimeInterval:ti_poll_res_seconds target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	}
	return self;
}

- (void) timerFireMethod:(NSTimer *)timer
{
//	NSLog(@"_nsmarr_db: %@", _nsmarr_db);
	
	NSPredicate* nspredicate= [NSPredicate predicateWithBlock:^BOOL(id evaluatedContext, NSDictionary<NSString *,id> *bindings) {
			if (! [evaluatedContext isKindOfClass:[Context class]])
				return NO;
		
			return [evaluatedContext expired] ? NO : YES;
		}];
	
	[_nsmarr_db filterUsingPredicate:nspredicate];
}

- (void) cacheEntry:(id)entry {
	[self cacheEntry:entry userInfo:nil andSeconds:knsti_ENTRY_EXP_NEVER];
}

- (void) cacheEntry:(id)entry andSeconds:(NSTimeInterval)nsti_s_TTL {
	[self cacheEntry:entry userInfo:nil andSeconds:nsti_s_TTL];
}

- (void) cacheEntry:(id)entry userInfo:(id)userInfo {
	[self cacheEntry:entry userInfo:userInfo andSeconds:knsti_ENTRY_EXP_NEVER];
}

- (void) cacheEntry:(id)entry userInfo:(id)userInfo andSeconds:(NSTimeInterval)nsti_s_TTL {
	[_nsmarr_db addObject: [Context contextWithEntry:entry userInfo:userInfo andSeconds:nsti_s_TTL]];
}

- (void) enumerateUsingBlock:(t_blk_Evaluate)blk_Evaluate {
	[_nsmarr_db enumerateObjectsUsingBlock:^(Context* context, NSUInteger idx, BOOL* p_bool_stop) {
			bool b_stop;
			blk_Evaluate(idx, context.entry, context.userInfo, &b_stop);
			*p_bool_stop= (b_stop) ? YES : NO;
		}];
}

- (void) enumerateAt:(NSUInteger)nsuint_idx usingBlock:(t_blk_Evaluate)blk_Evaluate {
	[_nsmarr_db enumerateObjectsUsingBlock:^(Context* context, NSUInteger evaluated_nsuint_idx, BOOL* p_bool_stop) {
			if (evaluated_nsuint_idx < nsuint_idx)
				return;
			bool b_stop;
			blk_Evaluate(evaluated_nsuint_idx, context.entry, context.userInfo, &b_stop);
			*p_bool_stop= (b_stop) ? YES : NO;
		}];
}

- (bool) contains:(id)entry idx:(NSUInteger*)p_nsuint_idx predicateIsEqual:(t_PredicateIsEqual)predicateIsEqual
{
	__block bool b_contains= false;
	__block NSUInteger nsuint_idx;
	
	[self enumerateUsingBlock:^(NSUInteger idx, id evaluated_entry, id evaluated_userInfo, bool* p_b_stop) {
			if (predicateIsEqual(entry, evaluated_entry)) {
				b_contains= true;
				nsuint_idx= idx;
				*p_b_stop= true;
			}
		}];
	
	*p_nsuint_idx= nsuint_idx;
	return b_contains;
}

- (bool) contains:(id)entry predicateIsEqual:(t_PredicateIsEqual)predicateIsEqual {
	NSUInteger nsint_idx;
	return [self contains:entry idx:&nsint_idx predicateIsEqual:predicateIsEqual];
}

- (bool) contains:(id)entry userInfo:(id*)p_userInfo predicateIsEqual:(t_PredicateIsEqual)predicateIsEqual
{
	NSUInteger nsint_idx;
	bool b_contains= [self contains:entry idx:&nsint_idx predicateIsEqual:predicateIsEqual];
	if (! b_contains)
		return b_contains;
	
	Context* context= _nsmarr_db[nsint_idx];
	*p_userInfo= context.userInfo;
	
	return b_contains;
}

- (void) expire:(id)id_Entry {
//	[_nsmdic_Cache removeObjectForKey:nsstr_Entry];
}

//- (NSEnumerator*) entryEnumerator {
//	return [_nsmdic_Cache keyEnumerator];
//}

@end

