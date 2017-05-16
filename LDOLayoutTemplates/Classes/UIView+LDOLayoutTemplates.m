//
//  UIView+LDOLayoutTemplates.m
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 27.04.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "UIView+LDOLayoutTemplates.h"
#import <objc/runtime.h>

@implementation UIView (LDOLayoutTemplates)

- (UIView *)targetView
{
    return objc_getAssociatedObject(self, @selector(targetView));
}

- (void)setTargetView:(UIView *)targetView
{
    objc_setAssociatedObject(self, @selector(targetView), targetView, OBJC_ASSOCIATION_ASSIGN);
}

- (NSArray<NSString *> *)transferableTemplateAttributeKeyPaths
{
    return @[
             @"alpha",
             @"hidden"
             ];
}

@end
