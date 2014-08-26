//
//  JPViewController.h
//  JPPopSequenceAnimation
//
//  Created by Juan Pedro Catalán on 26/08/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "JPPopSequenceAnimation.h"

@interface JPViewController : UIViewController <JPPopSequenceAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIView *squareView;
@property (weak, nonatomic) IBOutlet UIView *squareRed;

- (IBAction) animateSquare:(id)sender;

@end
