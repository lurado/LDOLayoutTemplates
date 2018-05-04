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

- (NSString *)transferredTemplateAttributeKeyPaths
{
    return objc_getAssociatedObject(self, @selector(transferredTemplateAttributeKeyPaths));
}

- (void)setTransferredTemplateAttributeKeyPaths:(NSString *)transferredTemplateAttributeKeyPaths
{
    BOOL isEmpty = [transferredTemplateAttributeKeyPaths stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
    NSString *keyPaths = isEmpty ? nil : transferredTemplateAttributeKeyPaths;
    objc_setAssociatedObject(self, @selector(transferredTemplateAttributeKeyPaths), keyPaths, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<NSString *> *)transferableTemplateAttributeKeyPaths
{
    NSMutableArray<NSString *> *keys = [NSMutableArray new];
    // we need to transfer the comma separated list as well, otherwise the views in the created default/current layout will miss it
    [keys addObject:@"transferredTemplateAttributeKeyPaths"];
    for (NSString *key in [self.transferredTemplateAttributeKeyPaths componentsSeparatedByString:@","]) {
        [keys addObject:[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    }
    return [keys copy];
}

@end
