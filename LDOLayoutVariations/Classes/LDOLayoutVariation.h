//
//  LDOLayoutVariation.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//  Copyright (c) 2017 Julian Raschke und Sebastian Ludwig GbR. All rights reserved.
//

@import Foundation;
#import "LDOVariationView.h"

@interface LDOLayoutVariation : NSObject

@property (nonatomic, weak) IBOutlet UIView *destinationView;
@property (nonatomic) IBOutlet UIView<LDOVariationView> *templateView;

// the resulting variation only restores the state of views that are also part of the given variation
+ (instancetype)layoutVariationForCurrentStateBasedOnVariation:(LDOLayoutVariation *)variation;

- (void)apply;

@end
