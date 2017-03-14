//
//  LDOLayoutVariationButton.h
//  LDOLayoutVariations
//
//  Created by Sebastian Ludwig on 13.03.2017.
//
//

@import UIKit;
#import "LDOVariationView.h"

@interface LDOLayoutVariationButton : UIButton <LDOVariationView>

@property (nonatomic, weak) IBOutlet UIButton *targetView;

@end
