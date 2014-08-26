//
//  JPPopSequenceAnimation.m
//  JPPopSequenceAnimation
//
//  Created by Juan Pedro Catalán on 20/08/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "JPPopSequenceAnimation.h"
#import "JPPopSequenceCoordinator.h"

NSInteger const JPPopSequenceRepeatForever = -1;

@interface JPPopSequenceAnimation (){
    
    NSInteger _indexSequence;
    NSInteger _mutableNumRepeats;

}

@property (nonatomic, weak) POPAnimation * currentAnimation;

- (void) _initialConfig;
- (void) _nextAnimation;
- (BOOL) _isThereMoreAnimations;
- (void) _playAnimationAtIndex:(NSInteger) index;

@end

@implementation JPPopSequenceAnimation


#pragma mark - Init -


- (id) initWithAnimationsList:(POPAnimation *) firstAnimation, ...
{
    self = [super init];
    if (self) {
        
        [self _initialConfig];
        
        NSMutableArray * animationsTemp = [NSMutableArray array];
        
        POPAnimation * eachObject;
        va_list argumentList;
        if ( firstAnimation )
        {
            [animationsTemp addObject:firstAnimation];
            
            va_start(argumentList, firstAnimation);
            while ( (eachObject = va_arg(argumentList, POPAnimation *)) )
            {
                [animationsTemp addObject: eachObject];
            }
            
            va_end(argumentList);
        }
        
        self.queueAnimations = animationsTemp;
        
    }
    return self;
}

- (id) initWithAnimations:(NSArray *) queue
{
    self = [super init];
    if (self) {
        
        [self _initialConfig];
        
        NSMutableArray * animationsTemp = [NSMutableArray arrayWithArray:queue];
        
        self.queueAnimations = animationsTemp;
    }
    return self;
}

- (void) setNumRepeats:(NSInteger)numRepeats{

    numRepeats = numRepeats;
    _mutableNumRepeats = numRepeats;
}

#pragma mark - Private Methods -

- (void) _initialConfig{

    self.beginIndex = 0;
    
    self.numRepeats = 0;
    _mutableNumRepeats = self.numRepeats;
    
    _running = NO;
    _paused = NO;
    
    self.queueAnimations = [NSMutableArray array];
}

- (void) _nextAnimation{
    
    if ([self _isThereMoreAnimations]) {
        
        //
        // Next animation
        //
        
        _indexSequence  += 1;
        
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(sequenceDidNextAnimation:atIndex:)]) {
                [self.delegate sequenceDidNextAnimation:self atIndex:_indexSequence];
            }
        }
        
        [self _playAnimationAtIndex:_indexSequence];
        
    }else{
        
        if (_mutableNumRepeats != 0 || self.numRepeats == JPPopSequenceRepeatForever) {
            
            //
            // Repeat sequence
            //
            
            _mutableNumRepeats -= 1;
            
            _indexSequence  = (self.beginIndex <= (self.queueAnimations.count - 1))?self.beginIndex:0;
            
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(sequenceDidNextAnimation:atIndex:)]) {
                    [self.delegate sequenceDidNextAnimation:self atIndex:_indexSequence];
                }
            }
            
            [self _playAnimationAtIndex:_indexSequence];
            
        }else{
        
            //
            // Finish sequence
            //
            
            [[JPPopSequenceCoordinator sharedSingleton] stopSequenceForKey:self.name
                                                                  toTarget:self.targetObject];
        }
    }
}

- (BOOL) _isThereMoreAnimations{

    NSInteger futureIndex = _indexSequence + 1;
    
    return (self.queueAnimations.count - 1) >= futureIndex;
}

- (void) _playAnimationAtIndex:(NSInteger) index{

    _running = YES;
    _paused = NO;
    
    self.currentAnimation   = [self.queueAnimations objectAtIndex:index];
    
    self.currentAnimation.delegate = self;
    
    [self.targetObject pop_addAnimation:self.currentAnimation
                                 forKey:self.currentAnimation.name];
}

#pragma mark - Queue -

- (void) addAnimation:(POPAnimation *) animation{

    [self.queueAnimations addObject:animation];
}

- (void) addAnimations:(NSArray *) animations{

    [self.queueAnimations addObjectsFromArray:animations];
}

#pragma mark - Actions -

- (void) startSequenceWithTarget:(id) target{

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sequenceDidStart:)]) {
            [self.delegate sequenceDidStart:self];
        }
    }
    
    self.targetObject = target;
    
    _indexSequence  = (self.beginIndex <= (self.queueAnimations.count - 1))?self.beginIndex:0;
    
    [self _playAnimationAtIndex:_indexSequence];
}

- (void) resumeSequence{
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sequenceDidResume:)]) {
            [self.delegate sequenceDidResume:self];
        }
    }
    
    [self _playAnimationAtIndex:_indexSequence];
}

- (void) stopSequence{
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sequenceDidStop:)]) {
            [self.delegate sequenceDidStop:self];
        }
    }
    
    _indexSequence  = (self.beginIndex <= (self.queueAnimations.count - 1))?self.beginIndex:0;
    _mutableNumRepeats  = self.numRepeats;
    
    _running = NO;
    
    [self.targetObject pop_removeAnimationForKey:self.currentAnimation.name];
}

- (void) pauseSequence{

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sequenceDidPause:)]) {
            [self.delegate sequenceDidPause:self];
        }
    }
    
    _running = NO;
    _paused = YES;
    
    [self.targetObject pop_removeAnimationForKey:self.currentAnimation.name];
}

#pragma mark - Pop Delegate - 

- (void)pop_animationDidStart:(POPAnimation *)anim{

    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sequence:animationDidStart:atIndex:)]) {
            [self.delegate sequence:self
                  animationDidStart:anim
                            atIndex:_indexSequence];
        }
    }
    
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(sequence:animationDidStop:atIndex:finished:)]) {
            [self.delegate sequence:self
                   animationDidStop:anim
                            atIndex:_indexSequence
                           finished:finished];
        }
    }
    
    if (finished) {
        
        [self _nextAnimation];
    }
}

@end


@implementation NSObject (JPPopSequence)

- (BOOL) alreadyExistSequenceWithKey:(NSString *)key{
    
    return [[JPPopSequenceCoordinator sharedSingleton] alreadyExistSequenceForKey:key
                                                                         toTarget:self];
}

- (void) addSequenceAnimation:(JPPopSequenceAnimation *) sequence forKey:(NSString *) key{

    [[JPPopSequenceCoordinator sharedSingleton] startSequence:sequence
                                                   withTarget:self
                                                       andKey:key];
}

- (void) resumeSequenceAnimationForKey:(NSString *) key{

    [[JPPopSequenceCoordinator sharedSingleton] resumeSequenceForKey:key
                                                            toTarget:self];
}

- (void) stopSequenceAnimationForKey:(NSString *) key{

    [[JPPopSequenceCoordinator sharedSingleton] stopSequenceForKey:key
                                                          toTarget:self];
}

- (void) pauseSequenceAnimationForKey:(NSString *) key{

    [[JPPopSequenceCoordinator sharedSingleton] pauseSequenceForKey:key
                                                           toTarget:self];
}

- (BOOL) isRunningSequenceForKey:(NSString *)key{

    return [[JPPopSequenceCoordinator sharedSingleton] alreadyExistSequenceForKey:key
                                                                         toTarget:self];
}

- (BOOL) isPausedSequenceForKey:(NSString *)key{
    
    return [[JPPopSequenceCoordinator sharedSingleton] alreadyExistSequenceForKey:key
                                                                         toTarget:self];
}

@end
