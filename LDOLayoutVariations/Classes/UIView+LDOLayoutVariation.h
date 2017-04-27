//
//  UIView+LDOLayoutVariation.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 27.04.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

@import UIKit;

@interface UIView (LDOLayoutVariation)

@property (nonatomic, weak) IBOutlet UIView *targetView;

- (NSArray<NSString *> *)layoutVariationAttributes;

@end
