//
//  LDOViewController.m
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "LDOViewController.h"
@import LDOLayoutVariations;

@interface LDOViewController ()

@property (nonatomic) LDOLayoutVariation *initialState;
@property (nonatomic, weak) IBOutlet LDOLayoutVariation *firstLayoutVariation;
@property (nonatomic, weak) IBOutlet LDOLayoutVariation *secondLayoutVariation;

@end

@implementation LDOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initialState = [LDOLayoutVariation layoutVariationForCurrentStateBasedOnVariation:self.firstLayoutVariation];
}

- (void)applyLayoutVariation:(LDOLayoutVariation *)variation
{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [variation apply];
                         
                         [self.view layoutIfNeeded];
                     }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [self applySecond];
    }
}

- (IBAction)reset
{
    [self applyLayoutVariation:self.initialState];
}

- (IBAction)applyFirst
{
    [self applyLayoutVariation:self.firstLayoutVariation];
}

- (IBAction)applySecond
{
    [self applyLayoutVariation:self.secondLayoutVariation];
}

@end
