//
//  LDOTargetingView.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//
//

#import "LDOVariationView.h"

@protocol LDOTargetingView <LDOVariationView>

@property (nonatomic, weak) IBOutlet UIView *targetView;

@end
