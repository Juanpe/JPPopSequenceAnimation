JPPopSequenceAnimation
======================

Runs POP Animations sequentially, one after another. 

## Installation

### Cocoapods

Edit Podfile and **add JPPopSequenceAnimation:**

```bash
pod 'JPPopSequenceAnimation'
```

### Manual

Clone the repository:

```bash
$ git clone https://github.com/Juanpe/JPPopSequenceAnimation.git
```

Drag and drop `JPPopSequenceAnimationClasses` folder into your project. Add `#import "JPPopSequenceAnimation.h"` to all view controllers that need to use it.

## Requirements

- iOS 7.0 or higher
- ARC

## Parameters

You can easily set the number of repetitions of sequence and set begin index:

```objective-c
@property (nonatomic) NSInteger beginIndex;
@property (nonatomic) NSInteger numRepeats;

sequenceAnimation.numRepeats = 2;
sequenceAnimation.numRepeats = JPPopSequenceRepeatForever; // Forever

sequenceAnimation.beginIndex = 1;
```

<br>
If you want to get animations callbacks, you must implement protocol named ```JPPopSequenceAnimationDelegate```.

<pre>
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
</pre>

## Sample Usage

```objective-c

        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anim.fromValue = @(1.0);
        anim.toValue = @(0.0);
        anim.name = @"fadeOut";
        
        POPBasicAnimation *anim1 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        anim1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        anim1.fromValue = @(0.0);
        anim1.toValue = @(1.0);
        anim.name = @"fadeIn";
        
        JPPopSequenceAnimation * sequenceAnimation = [[JPPopSequenceAnimation alloc] initWithAnimations:@[anim, anim1]];

        sequenceAnimation.delegate = self;

        [self.squareView addSequenceAnimation:sequenceAnimation
                                       forKey:@"sequence_1"];
```
