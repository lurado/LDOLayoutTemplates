//
//  LDOLayoutTemplate.h
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDOLayoutTemplate : NSObject

@property (nonatomic, weak) IBOutlet UIView *destinationView;
@property (nonatomic) IBOutlet UIView *templateView;

// the resulting template only restores the state of views that are also part of the given template
+ (instancetype)layoutTemplateForCurrentStateBasedOnTemplate:(LDOLayoutTemplate *)layoutTemplate;

// same as calling `applyConstraints`, then `applyAttributes`
- (void)apply;

// copies over all constraints from `templateView` to `destinationView`
- (void)applyConstraints;

// copies over all attributes from `templateView` to `destinationView`
- (void)applyAttributes;

@end
