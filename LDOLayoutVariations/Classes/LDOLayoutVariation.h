//
//  LDOLayoutVariation.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//
//

@import Foundation;
#import "LDOTargetingView.h"

@interface LDOLayoutVariation : NSObject

@property (nonatomic, weak) IBOutlet UIView *destinationView;
@property (nonatomic) IBOutlet UIView<LDOTargetingView> *templateView;

// the resulting variation only restores the state of views that are also part of the given variation
+ (instancetype)layoutVariationForCurrentStateBasedOnVariation:(LDOLayoutVariation *)variation;

- (void)applyInViewController:(UIViewController *)viewController;

@end
