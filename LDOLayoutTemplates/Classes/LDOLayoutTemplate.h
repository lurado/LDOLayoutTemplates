//
//  LDOLayoutTemplate.h
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDOLayoutTemplate : NSObject

@property (nullable, nonatomic, weak) IBOutlet UIView *destinationView;
@property (nullable, nonatomic) IBOutlet UIView *templateView;

// the resulting template only restores the state of views that are also part of the given template
+ (nonnull instancetype)layoutTemplateWithCurrentStateForViewsInTemplate:(nonnull LDOLayoutTemplate *)layoutTemplate NS_SWIFT_NAME(init(withCurrentStateForViewsIn:));

// same as calling `applyConstraints`, then `applyAttributes`
- (void)apply;

// copies over all constraints from `templateView` to `destinationView`
- (void)applyConstraints;

// copies over all attributes from `templateView` to `destinationView`
- (void)applyAttributes;

@end
