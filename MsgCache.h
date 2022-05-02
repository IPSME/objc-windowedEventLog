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

- (id) init;
- (id) initContextWithSeconds:(NSTimeInterval)nsti_s_TTL;
- (id) initContext:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL;

+ (EntryContext*) contextWithSeconds:(NSTimeInterval)nsti_s_TTL;
+ (EntryContext*) context:(id)id_Context withSeconds:(NSTimeInterval)nsti_s_TTL;

@end

@interface MsgCache : NSObject
{
	NSMutableDictionary* _nsmdic_Cache;
}

- (id) init;
//- (id) initWithMilliseconds:(NSTimeInterval)poll_res_milliseconds;

- (void) cacheEntry:(NSString*)nsstr_Entry withContext:(EntryContext*)entryContext;
- (BOOL) contains:(NSString*)nsstr_Entry context:(EntryContext**)entryContext;
- (void) expire:(NSString*)nsstr_Entry;

@end

#endif /* MsgCache_h */
