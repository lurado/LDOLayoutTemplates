//
//  UIView+LayoutTemplateAttributes.m
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 21.06.2017.
//  Copyright © 2017 sebastian@lurado.de. All rights reserved.
//

#import "UIView+LayoutTemplateAttributes.h"

@implementation UIView (LayoutTemplateAttributes)

- (NSArray<NSString *> *)transferableTemplateAttributeKeyPaths
{
    return @[
             @"alpha",
             @"hidden"
             ];
}

@end
