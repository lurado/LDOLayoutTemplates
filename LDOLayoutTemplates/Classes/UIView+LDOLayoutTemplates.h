//
//  UIView+LDOLayoutTemplates.h
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 27.04.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (LDOLayoutTemplates)

@property (nonatomic, weak) IBOutlet UIView *targetView;

// Add an Inspector property to take a comma separated list of attributes that will be transferred
@property (nonatomic) IBInspectable NSString *transferredTemplateAttributeKeyPaths;

- (NSArray<NSString *> *)transferableTemplateAttributeKeyPaths;

@end
