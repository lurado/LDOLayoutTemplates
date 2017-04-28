//
//  UIView+LDOLayoutTemplate.m
//  Pods
//
//  Created by Sebastian Ludwig on 27.04.2017.
//
//

#import "UIView+LDOLayoutTemplate.h"
#import <objc/runtime.h>

@implementation UIView (LDOLayoutTemplate)

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
