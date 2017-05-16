//
//  UICollectionView+LDOLayoutTemplates.m
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 16.05.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import "UICollectionView+LDOLayoutTemplates.h"
#import "UIView+LDOLayoutTemplates.h"

@implementation UICollectionView (LDOLayoutTemplates)

- (NSArray<NSString *> *)transferableTemplateAttributeKeyPaths
{
    NSArray *attributes = [super transferableTemplateAttributeKeyPaths];
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        return [attributes arrayByAddingObject:@"collectionViewLayout.scrollDirection"];
    }
    return attributes;
}

@end
