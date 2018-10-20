//
//  UIView+LDOLayoutTemplates.h
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 27.04.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (LDOLayoutTemplates)

@property (nullable, nonatomic, weak) IBOutlet UIView *targetView;

/// Inspectable, comma-separated list of key paths that will be transferred to `targetView`.
@property (nullable, nonatomic) IBInspectable NSString *templateAttributes;

/// An array of key paths that will transferred to targetView when the containing layout is applied.
/// The base implementation of this method includes the key paths from `templateAttributes`.
- (nonnull NSArray<NSString *> *)transferredTemplateAttributeKeyPaths;

@end
