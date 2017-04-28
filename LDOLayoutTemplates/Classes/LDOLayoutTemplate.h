//
//  LDOLayoutTemplate.h
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

@import Foundation;

@interface LDOLayoutTemplate : NSObject

@property (nonatomic, weak) IBOutlet UIView *destinationView;
@property (nonatomic) IBOutlet UIView *templateView;

// the resulting template only restores the state of views that are also part of the given template
+ (instancetype)layoutTemplateForCurrentStateBasedOnTemplate:(LDOLayoutTemplate *)layoutTemplate;

- (void)apply;

@end
