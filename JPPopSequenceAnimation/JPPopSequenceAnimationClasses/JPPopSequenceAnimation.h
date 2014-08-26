//
//  JPPopSequenceAnimation.h
//  JPPopSequenceAnimation
//
//  Created by Juan Pedro Catalán on 20/08/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <pop/POP.h>

@protocol JPPopSequenceAnimationDelegate;

extern NSInteger const JPPopSequenceRepeatForever;

@interface JPPopSequenceAnimation : NSObject <POPAnimationDelegate>

// +--------------------------------------------------------------
// | Properties
// +--------------------------------------------------------------
@property (copy, nonatomic) NSString *name;
@property (weak, nonatomic) id<JPPopSequenceAnimationDelegate> delegate;
@property (nonatomic, weak) id targetObject;
@property (assign, nonatomic, getter = isRunning) BOOL running;
@property (assign, nonatomic, getter = isPaused) BOOL paused;
@property (strong, nonatomic) NSMutableArray * queueAnimations;
@property (nonatomic) NSInteger beginIndex;
@property (nonatomic) NSInteger numRepeats;


// +--------------------------------------------------------------
// | Init
// +--------------------------------------------------------------
- (id) initWithAnimationsList:(POPAnimation *) firstAnimation, ...;
- (id) initWithAnimations:(NSArray *) queue;

// +--------------------------------------------------------------
// | Queue
// +--------------------------------------------------------------
- (void) addAnimation:(POPAnimation *) animation;
- (void) addAnimations:(NSArray *) animations;

// +--------------------------------------------------------------
// | Actions
// +--------------------------------------------------------------
- (void) startSequenceWithTarget:(id) target;
- (void) resumeSequence;
- (void) stopSequence;
- (void) pauseSequence;


@end

@interface NSObject (JPPopSequence)

- (void) addSequenceAnimation:(JPPopSequenceAnimation *) sequence forKey:(NSString *) key;
- (void) resumeSequenceAnimationForKey:(NSString *) key;
- (void) stopSequenceAnimationForKey:(NSString *) key;
- (void) pauseSequenceAnimationForKey:(NSString *) key;
- (BOOL) alreadyExistSequenceWithKey:(NSString *)key;
- (BOOL) isRunningSequenceForKey:(NSString *)key;
- (BOOL) isPausedSequenceForKey:(NSString *)key;

@end



@protocol JPPopSequenceAnimationDelegate <NSObject>

@optional

- (void) sequenceDidStart:(JPPopSequenceAnimation *) sequence;
- (void) sequenceDidResume:(JPPopSequenceAnimation *) sequence;
- (void) sequenceDidStop:(JPPopSequenceAnimation *) sequence;
- (void) sequenceDidPause:(JPPopSequenceAnimation *) sequence;
- (void) sequenceDidNextAnimation:(JPPopSequenceAnimation *) sequence
                          atIndex:(NSInteger) index;


- (void) sequence:(JPPopSequenceAnimation *) sequence
animationDidStart:(POPAnimation *) anim
          atIndex:(NSInteger) index;

- (void) sequence:(JPPopSequenceAnimation *) sequence
 animationDidStop:(POPAnimation *) anim
          atIndex:(NSInteger) index
         finished:(BOOL) finished;


@end




