//
//  ViewController.m
//  LDOLayoutTemplates Example
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "ViewController.h"
#import "LDOLayoutTemplate.h"

@interface ViewController ()

@property (nonatomic) LDOLayoutTemplate *defaultLayout;
@property (nonatomic, weak) IBOutlet LDOLayoutTemplate *firstLayout;
@property (nonatomic, weak) IBOutlet LDOLayoutTemplate *secondLayout;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a backup of the initial view contents for later restoration.
    self.defaultLayout = [LDOLayoutTemplate layoutTemplateWithCurrentStateForViewsInTemplate:self.firstLayout];
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

- (IBAction)reset
{
    [self applyLayoutTemplate:self.defaultLayout];
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
