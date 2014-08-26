//
//  JPPopSequenceCoordinator.h
//  JPPopSequenceAnimation
//
//  Created by Juan Pedro Catalán on 26/08/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "JPPopSequenceAnimation.h"

@interface JPPopSequenceCoordinator : NSObject

//  +-----------------------------------------------------------------
//  | Properties
//  +-----------------------------------------------------------------
@property (nonatomic, strong) NSMutableDictionary * sequences;

//  +-----------------------------------------------------------------
//  | Singleton
//  +-----------------------------------------------------------------
+ (JPPopSequenceCoordinator *)sharedSingleton;

//  +-----------------------------------------------------------------
//  | Actions
//  +-----------------------------------------------------------------
- (void) startSequence:(JPPopSequenceAnimation *) sequence withTarget:(id) target andKey:(NSString *) key;
- (void) resumeSequenceForKey:(NSString *) key toTarget:(id) target;
- (void) stopSequenceForKey:(NSString *) key toTarget:(id) target;
- (void) finalizeSequenceForKey:(NSString *) key toTarget:(id) target;
- (void) pauseSequenceForKey:(NSString *) key toTarget:(id) target;
- (BOOL) alreadyExistSequenceForKey:(NSString *) key toTarget:(id) target;
- (BOOL) isRunningSequenceForKey:(NSString *) key toTarget:(id) target;
- (BOOL) isPausedSequenceForKey:(NSString *) key toTarget:(id) target;

@end
