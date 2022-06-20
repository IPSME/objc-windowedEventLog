//
//  MsgCache.h
//  objc-hubs-mask
//
//  Created by dev on 2022-04-28.
//  Copyright © 2022 Root Interface AB. All rights reserved.
//

#ifndef MsgCache_h
#define MsgCache_h

@interface EntryContext : NSObject
{
	NSTimeInterval _nsti_s_TTL;
	NSDate* _nsdt_instant;
}

@property id context;

+ (EntryContext*) contextWithSeconds:(NSTimeInterval)nsti_s_TTL;
+ (EntryContext*) context:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL;

- (id) init;
- (id) initContextWithSeconds:(NSTimeInterval)nsti_s_TTL;
- (id) initContext:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL;

- (BOOL) expired;

@end

extern const NSTimeInterval kti_POLL_RES_MILLISECONDS;

@interface MsgCache : NSObject
{
	NSMutableDictionary* _nsmdic_Cache;
	NSTimer* _timer;
}

- (id) init;
- (id) initWithSeconds:(NSTimeInterval)ti_poll_res_seconds;

- (void) cacheEntry:(NSString*)nsstr_Entry withContext:(EntryContext*)entryContext;
- (BOOL) contains:(NSString*)nsstr_Entry;
- (BOOL) contains:(NSString*)nsstr_Entry context:(EntryContext**)p_entryContext;
- (void) expire:(NSString*)nsstr_Entry;

@end

#endif /* MsgCache_h */
