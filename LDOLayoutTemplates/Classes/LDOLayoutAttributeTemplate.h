//
//  LDOLayoutAttributeTemplate.h
//  LDOLayoutTemplates
//
//  Created by Sebastian Ludwig on 16.05.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LDOLayoutAttributeTemplate <NSObject>

- (NSArray<NSString *> *)transferableTemplateAttributeKeyPaths;

@end
