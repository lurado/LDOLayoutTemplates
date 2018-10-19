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

// this Inspector property takes a comma-separated list of attributes that will be transferred
@property (nullable, nonatomic) IBInspectable NSString *transferredTemplateAttributeKeyPaths;

- (nonnull NSArray<NSString *> *)transferableTemplateAttributeKeyPaths;

@end
