//
//  LDOLayoutTemplate.h
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDOLayoutTemplate : UIView

/// Returns a template that restores the state of views that are also part of the given `layoutTemplate`.
+ (nonnull instancetype)layoutTemplateWithCurrentStateForViewsInTemplate:(nonnull LDOLayoutTemplate *)layoutTemplate NS_SWIFT_NAME(init(withCurrentStateForViewsIn:));

/// Same as calling `applyConstraints`, then `applyAttributes`.
- (void)apply;

/// Copies over all constraints to `targetView`.
- (void)applyConstraints;

/// Copies over all attributes to `targetView`.
- (void)applyAttributes;

@end
