//
//  MsgCache.h
//  objc-hubs-mask
//
//  Created by dev on 2022-04-28.
//  Copyright © 2022 Root Interface AB. All rights reserved.
//

#ifndef MsgCache_h
#define MsgCache_h

extern const NSTimeInterval kti_POLL_RES_MILLISECONDS;

@interface MsgCache<t_Entry, t_UserInfo> : NSObject // Generics
{
	NSMutableArray* _nsmarr_db;
	NSTimer* _timer;
}

typedef void (^t_blk_Evaluate)(NSUInteger nsunit_idx, t_Entry entry, t_UserInfo userInfo, bool* pb_stop);
typedef bool (^t_PredicateIsEqual)(id entry1, id entry2);

- (instancetype) init;
- (instancetype) initWithSeconds:(NSTimeInterval)ti_poll_res_seconds;

- (void) cacheEntry:(t_Entry)entry;
- (void) cacheEntry:(t_Entry)entry andSeconds:(NSTimeInterval)nsti_s_TTL;
- (void) cacheEntry:(t_Entry)entry userInfo:(t_UserInfo)userInfo;
- (void) cacheEntry:(t_Entry)entry userInfo:(t_UserInfo)userInfo andSeconds:(NSTimeInterval)nsti_s_TTL;

- (void) enumerateUsingBlock:(t_blk_Evaluate)blk_Evaluate;
- (void) enumerateAt:(NSUInteger)nsuint_idx usingBlock:(t_blk_Evaluate)blk_Evaluate;

//- (bool) contains:(t_Entry)entry predicateIsEqual:(t_PredicateIsEqual)predicateIsEqual;
//- (bool) contains:(t_Entry)entry userInfo:(t_UserInfo*)p_userInfo predicateIsEqual:(t_PredicateIsEqual)predicateIsEqual;

- (void) expire:(t_Entry)entry;


// NSEnumerator* enumerator= [msgCache_ entryEnumerator];
// NSString* nsstr_Entry;
// while((nsstr_Entry= [enumerator nextObject]) != nil) {
//     EntryContext* entryContext;
//     [msgCache_ contains:nsstr_Entry context:&entryContext];
//}
//- (NSEnumerator*) entryEnumerator;

@end

#endif /* MsgCache_h */
