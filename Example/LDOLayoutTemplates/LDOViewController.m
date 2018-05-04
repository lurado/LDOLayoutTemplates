//
//  LDOViewController.m
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "LDOViewController.h"
@import LDOLayoutTemplates;

@interface LDOViewController ()

@property (nonatomic) LDOLayoutTemplate *initialState;
@property (nonatomic, weak) IBOutlet LDOLayoutTemplate *firstLayout;
@property (nonatomic, weak) IBOutlet LDOLayoutTemplate *secondLayout;

@end

@implementation LDOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initialState = [LDOLayoutTemplate layoutTemplateForCurrentStateBasedOnTemplate:self.firstLayout];
}

- (void)applyLayoutTemplate:(LDOLayoutTemplate *)template
{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [template apply];
                         
                         [self.view layoutIfNeeded];
                     }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (size.width > size.height) {
        [self applySecond];
    }
}

- (IBAction)reset
{
    [self applyLayoutTemplate:self.initialState];
}

- (IBAction)applyFirst
{
    [self applyLayoutTemplate:self.firstLayout];
}

- (IBAction)applySecond
{
    [self applyLayoutTemplate:self.secondLayout];
}

@end
