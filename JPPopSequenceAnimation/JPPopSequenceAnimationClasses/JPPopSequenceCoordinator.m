//
//  JPPopSequenceCoordinator.m
//  JPPopSequenceAnimation
//
//  Created by Juan Pedro Catalán on 26/08/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "JPPopSequenceCoordinator.h"

@interface JPPopSequenceCoordinator ()

- (void) _addSequence:(JPPopSequenceAnimation *) seq withKey:(NSString *) key toTarget:(id) target;
- (void) _removeSequenceWithKey:(NSString *) key toTarget:(id) target;
- (NSMutableDictionary *) _sequencesForObject:(id)target;

@end

@implementation JPPopSequenceCoordinator

+ (JPPopSequenceCoordinator *)sharedSingleton {
    
    static JPPopSequenceCoordinator *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[self alloc] initSingleton];
    });
    
    return _sharedSingleton;
}

- (JPPopSequenceCoordinator*)initSingleton {
    self = [super init];
    if (self) {
        self.sequences = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)init
{
    return nil;
}

+ (id)new
{
    return nil;
}

#pragma mark - Actions -

- (void) startSequence:(JPPopSequenceAnimation *) sequence withTarget:(id) target andKey:(NSString *) key{

    if (![self alreadyExistSequenceForKey:key toTarget:target]) {
        
        [sequence setName:key];
        
        [self _addSequence:sequence
                   withKey:key
                  toTarget:target];
        
        [sequence startSequenceWithTarget:target];
        
    }else{
        NSLog(@"[%@]: Already exist one sequence with key = %@ to target %@", NSStringFromClass([self class]), key, target);
    }
}

- (void) resumeSequenceForKey:(NSString *) key toTarget:(id) target{

    NSMutableDictionary * sequenceTarget = [self _sequencesForObject:target];
    JPPopSequenceAnimation * sequence = [sequenceTarget objectForKey:key];
    if (sequence) {
        
        [sequence resumeSequence];
    }else{
        NSLog(@"[%@]: No exist sequence with key = %@ to resume", NSStringFromClass([self class]), key);
    }
}

- (void) stopSequenceForKey:(NSString *) key toTarget:(id) target{

    NSMutableDictionary * sequenceTarget = [self _sequencesForObject:target];
    JPPopSequenceAnimation * sequence = [sequenceTarget objectForKey:key];
    if (sequence) {
        
        [sequence stopSequence];
        [self _removeSequenceWithKey:key
                            toTarget:target];
        
    }else{
        NSLog(@"[%@]: No exist sequence with key = %@ to stop", NSStringFromClass([self class]), key);
    }
}

- (void) finalizeSequenceForKey:(NSString *) key toTarget:(id) target{

    [self _removeSequenceWithKey:key
                        toTarget:target];
}

- (void) pauseSequenceForKey:(NSString *) key toTarget:(id) target{
    
    NSMutableDictionary * sequenceTarget = [self _sequencesForObject:target];
    JPPopSequenceAnimation * sequence = [sequenceTarget objectForKey:key];
    if (sequence) {
        
        [sequence pauseSequence];
    }else{
        NSLog(@"[%@]: No exist sequence with key = %@ to pause", NSStringFromClass([self class]), key);
    }
}

- (BOOL) alreadyExistSequenceForKey:(NSString *) key toTarget:(id) target{
    
    NSMutableDictionary * sequencesToTarget = [self _sequencesForObject:target];
    
    JPPopSequenceAnimation * sequence = [sequencesToTarget objectForKey:key];
    return sequence != nil;
}

- (BOOL) isRunningSequenceForKey:(NSString *) key toTarget:(id) target{

    if ([self alreadyExistSequenceForKey:key toTarget:target]) {
        
        NSMutableDictionary * sequenceTarget = [self _sequencesForObject:target];
        JPPopSequenceAnimation * sequence = [sequenceTarget objectForKey:key];

        return sequence.isRunning;
        
    }else{
        return NO;
    }
}

- (BOOL) isPausedSequenceForKey:(NSString *) key toTarget:(id) target{

    if ([self alreadyExistSequenceForKey:key toTarget:target]) {
        
        NSMutableDictionary * sequenceTarget = [self _sequencesForObject:target];
        JPPopSequenceAnimation * sequence = [sequenceTarget objectForKey:key];
        
        return sequence.isPaused;
        
    }else{
        return NO;
    }
}

#pragma mark - Private Methods -

- (void) _addSequence:(JPPopSequenceAnimation *) seq withKey:(NSString *) key toTarget:(id) target{

    NSNumber *keyObj = [NSNumber numberWithUnsignedInteger:[target hash]];
    
    NSMutableDictionary * sequenceTarget = [self _sequencesForObject:keyObj];
    
    [sequenceTarget setObject:seq
                       forKey:key];
    
    [self.sequences setObject:sequenceTarget
                       forKey:keyObj];
}

- (void) _removeSequenceWithKey:(NSString *) key toTarget:(id) target{

    NSMutableDictionary * sequenceTarget = [self _sequencesForObject:target];

    [sequenceTarget removeObjectForKey:key];
    
    NSNumber *keyObj = [NSNumber numberWithUnsignedInteger:[target hash]];
    
    [self.sequences setObject:sequenceTarget
                       forKey:keyObj];
}

- (NSMutableDictionary *) _sequencesForObject:(id)target{
    
    NSNumber *keyObj = [NSNumber numberWithUnsignedInteger:[target hash]];
    
    NSMutableDictionary * sequencesToTarget = [self.sequences objectForKey:keyObj];
    
    if (!sequencesToTarget) {
        
        sequencesToTarget = [NSMutableDictionary dictionary];
        
        [self.sequences setObject:sequencesToTarget
                           forKey:keyObj];
    }
    
    return sequencesToTarget;
}

@end
