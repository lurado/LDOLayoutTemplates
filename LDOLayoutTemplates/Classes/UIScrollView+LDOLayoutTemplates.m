//
//  UIScrollView+LDOLayoutTemplates.m
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 16.05.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "UIScrollView+LDOLayoutTemplates.h"
#import "UIView+LDOLayoutTemplates.h"

@implementation UIScrollView (LDOLayoutTemplates)

- (NSArray<NSString *> *)transferableTemplateAttributeKeyPaths
{
    return [[super transferableTemplateAttributeKeyPaths] arrayByAddingObject:@"scrollEnabled"];
}

@end
