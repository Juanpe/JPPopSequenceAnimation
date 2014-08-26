//
//  JPViewController.m
//  JPPopSequenceAnimation
//
//  Created by Juan Pedro Catalán on 26/08/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "JPViewController.h"
#import "JPPopSequenceAnimation.h"

@interface JPViewController ()

@end

@implementation JPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) animateSquare:(id)sender{

    if ([self.squareView alreadyExistSequenceWithKey:@"sequence_1"]) {
        
        [self.squareView stopSequenceAnimationForKey:@"sequence_1"];
        
    }else{
    
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
        sequenceAnimation.numRepeats = JPPopSequenceRepeatForever;
        sequenceAnimation.delegate = self;
        [self.squareView addSequenceAnimation:sequenceAnimation
                                       forKey:@"sequence_1"];
    }
    
    
    if ([self.squareRed alreadyExistSequenceWithKey:@"sequence_1"]) {
        
        [self.squareRed stopSequenceAnimationForKey:@"sequence_1"];
        
    }else{
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
        anim.name = @"scale2x";
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(self.squareRed.frame.origin.x, self.squareRed.frame.origin.y, 200, 200)];
        
        POPSpringAnimation *anim1 = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
        anim1.name = @"scale1x";
        anim1.toValue = [NSValue valueWithCGRect:CGRectMake(self.squareRed.frame.origin.x, self.squareRed.frame.origin.y, 150, 150)];
        
        JPPopSequenceAnimation * sequenceAnimation = [[JPPopSequenceAnimation alloc] initWithAnimationsList:anim, anim1, nil];
        
        sequenceAnimation.delegate = self;
        
        [self.squareRed addSequenceAnimation:sequenceAnimation
                                       forKey:@"sequence_1"];
    }
}

#pragma mark - Sequence Delegate - 

- (void) sequenceDidStart:(JPPopSequenceAnimation *) sequence{
    NSLog(@"%s => %@ to target: %ld",__FUNCTION__, sequence.name, [sequence.targetObject hash]);
}

- (void) sequenceDidNextAnimation:(JPPopSequenceAnimation *) sequence atIndex:(NSInteger) index{
    NSLog(@"%s [%lu] => %@ to target: %ld",__FUNCTION__, index,sequence.name, [sequence.targetObject hash]);
}

- (void) sequenceDidResume:(JPPopSequenceAnimation *) sequence{
    NSLog(@"%s => %@ to target: %ld",__FUNCTION__, sequence.name, [sequence.targetObject hash]);
}

- (void) sequenceDidStop:(JPPopSequenceAnimation *) sequence{
    NSLog(@"%s => %@ to target: %ld",__FUNCTION__, sequence.name, [sequence.targetObject hash]);
}

- (void) sequenceDidPause:(JPPopSequenceAnimation *) sequence{
    NSLog(@"%s => %@ to target: %ld",__FUNCTION__, sequence.name, [sequence.targetObject hash]);
}

- (void) sequence:(JPPopSequenceAnimation *) sequence animationDidStart:(POPAnimation *) anim atIndex:(NSInteger) index{
    NSLog(@"%s => %@ animation named: %@ to target: %ld at index: %ld",__FUNCTION__, anim.name,sequence.name, [sequence.targetObject hash], (long)index);
}

- (void) sequence:(JPPopSequenceAnimation *) sequence animationDidStop:(POPAnimation *) anim atIndex:(NSInteger) index finished:(BOOL) finished{
    NSLog(@"%s => %@ animation named: %@ to target: %lu at index: %ld finished: %d",__FUNCTION__, sequence.name, anim.name, (unsigned long)[sequence.targetObject hash], (long)index, finished);
}

@end
