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

- (NSString *)templateAttributes
{
    return objc_getAssociatedObject(self, @selector(templateAttributes));
}

- (void)setTemplateAttributes:(NSString *)templateAttributes
{
    BOOL isEmpty = [templateAttributes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
    NSString *keyPaths = isEmpty ? nil : templateAttributes;
    objc_setAssociatedObject(self, @selector(templateAttributes), keyPaths, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<NSString *> *)transferredTemplateAttributeKeyPaths
{
    NSMutableArray<NSString *> *keys = [NSMutableArray new];
    // We need to transfer the comma separated list as well, otherwise views created by +[LDOLayoutTemplate layoutTemplateWithCurrentStateForViewsInTemplate:] will not transfer these key paths back.
    [keys addObject:@"templateAttributes"];
    for (NSString *key in [self.templateAttributes componentsSeparatedByString:@","]) {
        [keys addObject:[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    return [keys copy];
}

@end
